#!/usr/bin/env python3

import json
from dataclasses import dataclass
from os import environ
from subprocess import DEVNULL, check_output, run
from typing import Callable, Dict, List

BINARY_CACHE_URLS = [
    "https://internetunexplorer.cachix.org",
    "https://cache.nixos.org",
]


@dataclass
class Package:
    path: str
    broken: bool

    def is_in_cache(self, cache: str) -> bool:
        command = ["nix", "path-info", "--store", cache, self.path]
        return run(command, stdout=DEVNULL, stderr=DEVNULL).returncode == 0

    def is_in_any_cache(self) -> bool:
        return any(self.is_in_cache(cache) for cache in BINARY_CACHE_URLS)

    def should_be_built(self) -> bool:
        return not self.broken and not self.is_in_any_cache()


def get_packages() -> Dict[str, Package]:
    output = check_output(
        [
            "nix",
            "eval",
            "--impure",
            "--recreate-lock-file",
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

    return {name: Package(**fields) for name, fields in json.loads(output).items()}


def filter_packages(
    predicate: Callable[[Package], bool], packages: Dict[str, Package]
) -> Dict[str, Package]:
    return {name: package for name, package in packages.items() if predicate(package)}


def print_packages(title: str, packages: List[Package]) -> None:
    print(f"———— {title} ".ljust(60, "—"))
    for package in packages or [None]:
        print(f"- {package.path if package else '(none)'}")


if __name__ == "__main__":
    packages = get_packages()
    broken_packages = filter_packages(lambda package: package.broken, packages)
    packages_to_build = filter_packages(Package.should_be_built, packages)

    print("```text")
    print_packages("Packages in flake", list(packages.values()))
    print()
    print_packages("Packages marked as broken", list(broken_packages.values()))
    print()
    print_packages("Packages to be built", list(packages_to_build.values()))
    print("```")

    if "GITHUB_OUTPUT" in environ:
        with open(environ["GITHUB_OUTPUT"], "a") as file:
            print(f"packages={json.dumps(list(packages_to_build.keys()))}", file=file)
