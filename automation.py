#!/usr/bin/env python3

import json
from argparse import ArgumentParser
from dataclasses import dataclass
from os import environ
from subprocess import DEVNULL, PIPE, CompletedProcess
from subprocess import run as _run
from sys import stderr
from typing import Any, List, Set

################################################################
## General Utilities
################################################################


def run(*command: str, **kwargs) -> CompletedProcess[Any]:
    """Wrapper around `run` that prints the command."""
    format_arg = lambda arg: repr(arg) if " " in arg else arg
    print(f"\033[34m$ {' '.join(map(format_arg, command))}\033[0m", file=stderr)
    return _run(list(command), **kwargs)


def nix(*args: str) -> str:
    """Run `nix <ARGS>` and return the output."""
    return run("nix", *args, stdout=PIPE, check=True).stdout.decode("utf-8")


def nix_eval_json(*args: str) -> Any:
    """Run `nix eval --json <ARGS>` and parse and return the output."""
    return json.loads(nix("eval", "--json", *args))


def set_github_output(key: str, value: Any) -> None:
    """Set the specified (JSON) output if running in GitHub Actions."""
    if "GITHUB_OUTPUT" in environ:
        with open(environ["GITHUB_OUTPUT"], "a") as file:
            packages = [package.name for package in value]
            print(f"${key}={json.dumps(packages)}", file=file)


################################################################
## Package Utilities
################################################################


@dataclass(frozen=True)
class Package:
    name: str
    path: str
    broken: bool
    has_update_script: bool

    def is_in_cache(self, cache: str) -> bool:
        """Check whether the package is in the specified binary cache."""
        command = ["nix", "path-info", "--store", cache, self.path]
        return run(*command, stdout=DEVNULL, stderr=DEVNULL).returncode == 0

    def is_in_any_cache(self, caches: List[str]) -> bool:
        """Check whether the package is in any of the specified binary caches."""
        return any(self.is_in_cache(cache) for cache in caches)


def get_all_packages() -> Set[Package]:
    """Get all the packages in `.#packages.${builtins.currentSystem}`."""
    system = nix_eval_json("--impure", "--expr", "builtins.currentSystem")
    all_packages = nix_eval_json(
        f".#packages.{system}",
        "--apply",
        "builtins.mapAttrs (_: drv: {"
        " path = drv.outPath;"
        " broken = drv.meta.broken;"
        " has_update_script = drv.passthru ? updateScript;"
        " })",
    )
    return {Package(name, **attrs) for name, attrs in all_packages.items()}


def print_packages(title: str, packages: Set[Package]) -> None:
    """Display a set of packages in alphabetical order by store path."""
    print(f"**{title}:**")
    for package in sorted(list(packages), key=lambda p: p.name) or [None]:
        print(f"- {package.path if package else '(none)'}")
    print()


################################################################
## Main Stuff
################################################################


def get_packages_to_build() -> None:
    """Get the list of packages to build (not broken or cached)."""
    caches = list(nix("show-config", "substituters").split())
    all_packages = get_all_packages()
    broken_packages = {package for package in all_packages if package.broken}
    cached_packages = {
        package
        for package in all_packages - broken_packages
        if package.is_in_any_cache(caches)
    }
    packages_to_build = all_packages - broken_packages - cached_packages
    print_packages("These packages will be built", packages_to_build)
    print_packages("These packages are marked as broken", broken_packages)
    print_packages("These packages have already been built", cached_packages)
    set_github_output("packages", packages_to_build)


def get_packages_to_update() -> None:
    """Get the list of packages to update (has `passthru.updateScript`)."""
    all_packages = get_all_packages()
    packages_to_update = {
        package for package in all_packages if package.has_update_script
    }
    print_packages("These packages support automated updates", packages_to_update)


def update_package(name: str) -> None:
    """Update the specified package and commit the changes, if any."""
    version_pre = nix_eval_json(f".#{name}.version")
    nix("run", f".#{name}.passthru.updateScript")
    version_post = nix_eval_json(f".#{name}.version")
    if version_pre != version_post:
        commit_message = f"{name}: {version_pre} -> {version_post}"
        run("git", "commit", "-m", commit_message, "--", name)


if __name__ == "__main__":
    parser = ArgumentParser(description="nixpkgs-overlay automation helper")
    command = parser.add_subparsers(dest="command", required=True)
    command.add_parser("get-packages-to-build", help="get list of packages to build")
    command.add_parser("get-packages-to-update", help="get list of packages to update")
    update = command.add_parser("update-package", help="update the specified package")
    update.add_argument("name", help="name of the package to update")
    args = parser.parse_args()
    try:
        {
            "get-packages-to-build": get_packages_to_build,
            "get-packages-to-update": get_packages_to_update,
            "update-package": lambda: update_package(args.name),
        }[args.command]()
    except Exception as error:
        print(f"\033[31m{type(error).__name__}: {error}\033[0m", file=stderr)
