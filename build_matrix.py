#!/usr/bin/env python3

import json
from dataclasses import dataclass
from os import environ
from subprocess import check_output, run, DEVNULL
from typing import Dict, List

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


def print_packages(title: str, packages: List[Package]) -> None:
    BLUE, RESET = "\033[34m", "\033[0m"
    print(BLUE + f"---- {title} ".ljust(60, "-") + RESET)
    for package in packages or [None]:
        print(f"  {package.path if package else '(none)'}")
    print()


if __name__ == "__main__":
    print()

    packages = get_packages()
    print_packages("Packages in flake", list(packages.values()))

    broken_packages = [name for name, package in packages.items() if package.broken]
    print_packages(
        "Packages marked as broken", [packages[name] for name in broken_packages]
    )

    packages_to_build = [
        name for name, package in packages.items() if package.should_be_built()
    ]
    print_packages(
        "Packages to be built", [packages[name] for name in packages_to_build]
    )

    print("::set-output", f"name=packages::{json.dumps(packages_to_build)}")
