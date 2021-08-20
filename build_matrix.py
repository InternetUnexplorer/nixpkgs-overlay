#!/usr/bin/env python3

from subprocess import check_output, run, DEVNULL
from typing import Dict, List
import json


BINARY_CACHE_URLS = [
    "https://internetunexplorer.cachix.org",
    "https://cache.nixos.org",
]


def get_packages() -> Dict[str, str]:
    output = check_output(
        [
            "nix",
            "eval",
            "--recreate-lock-file",
            "--json",
            ".#packages.x86_64-linux",
        ]
    )
    return json.loads(output)


def is_path_in_cache(path: str, cache_url: str) -> bool:
    result = run(
        ["nix", "path-info", "--store", cache_url, path], stdout=DEVNULL, stderr=DEVNULL
    )
    return result.returncode == 0


def is_path_in_any_cache(path: str) -> bool:
    return any(map(lambda c: is_path_in_cache(path, c), BINARY_CACHE_URLS))


def get_packages_to_build(packages: Dict[str, str]) -> List[str]:
    return [name for name, path in packages.items() if not is_path_in_any_cache(path)]


if __name__ == "__main__":
    packages = get_packages()

    print("PACKAGES IN FLAKE:")
    for path in packages.values():
        print(" ", path)
    print()

    packages_to_build = get_packages_to_build(packages)
    print("PACKAGES TO BE BUILT:")
    for path in [packages[name] for name in packages_to_build]:
        print(" ", path)
    print()

    print("::set-output", f"name=packages::{json.dumps(packages_to_build)}")
