#!/usr/bin/env python3

import json
from dataclasses import dataclass
from os import environ
from subprocess import DEVNULL, check_output, run
from typing import Set, List

BINARY_CACHE_URLS = [
    "https://internetunexplorer.cachix.org",
    "https://cache.nixos.org",
]


@dataclass(frozen=True)
class Package:
    name: str
    path: str
    broken: bool

    def is_in_cache(self, cache: str) -> bool:
        command = ["nix", "path-info", "--store", cache, self.path]
        return run(command, stdout=DEVNULL, stderr=DEVNULL).returncode == 0

    def is_in_any_cache(self) -> bool:
        return any(self.is_in_cache(cache) for cache in BINARY_CACHE_URLS)


def get_all_packages() -> Set[Package]:
    output = check_output(
        [
            "nix",
            "eval",
            "--impure",
            "--json",
            ".#packages.x86_64-linux",
            "--apply",
            """
            builtins.mapAttrs (_: drv: {
                path = drv.outPath;
                broken = drv.meta.broken;
            })
            """,
        ],
        env=dict(environ, NIXPKGS_ALLOW_BROKEN="1"),
    )

    return {Package(name, **attrs) for name, attrs in json.loads(output).items()}


def print_packages(title: str, packages: Set[Package]) -> None:
    print(f"**{title}:**")
    for package in sorted(list(packages), key=lambda p: p.name) or [None]:
        print(f"- {package.path if package else '(none)'}")
    print()


if __name__ == "__main__":
    all_packages = get_all_packages()
    broken_packages = {p for p in all_packages if p.broken}
    built_packages = {p for p in all_packages - broken_packages if p.is_in_any_cache()}
    packages_to_build = all_packages - broken_packages - built_packages

    print_packages("These packages will be built", packages_to_build)
    print_packages("These packages are marked as broken", broken_packages)
    print_packages("These packages have already been built", built_packages)

    if "GITHUB_OUTPUT" in environ:
        with open(environ["GITHUB_OUTPUT"], "a") as file:
            packages = [package.name for package in packages_to_build]
            print(f"packages={json.dumps(packages)}", file=file)
