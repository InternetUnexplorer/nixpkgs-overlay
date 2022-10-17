#!/usr/bin/env python3

import json
from os import environ
from subprocess import DEVNULL, PIPE, run
from sys import argv
from tempfile import TemporaryDirectory
from time import gmtime, strftime
from typing import Any, Dict, List, Optional
from urllib.request import Request, urlopen

PACKAGES = ".#packages.x86_64-linux"

################################################


def set_output(name: str, value: Any) -> None:
    """Set an output for a GitHub actions step."""
    if not "GITHUB_OUTPUT" in environ:
        print("warning: $GITHUB_OUTPUT not set")
        return
    with open(environ["GITHUB_OUTPUT"], "a") as file:
        print(f"{name}={json.dumps(value)}", file=file)


################################################


def get_stdout(command: List[str], **kwargs) -> str:
    """Run `command` and return the output."""
    process = run(command, stdout=PIPE, check=True, **kwargs)
    return process.stdout.decode("utf-8")


def get_stdout_json(command: List[str], **kwargs) -> Any:
    """Run `command` and parse the output as JSON."""
    return json.loads(get_stdout(command, **kwargs))


def flake_path() -> str:
    """Get the path of this flake in the nix store."""
    output = get_stdout_json(
        ["nix", "flake", "archive", "--quiet", "--quiet", "--quiet", "--json"]
    )
    return output["path"]


def nix_eval(attr: str, apply: str = None) -> Any:
    """Return the value of `attr`, optionally applying a function."""
    command = ["nix", "eval", "--quiet", "--quiet", "--quiet", "--json", attr]
    if apply:
        command.extend(["--apply", apply])
    return get_stdout_json(command)


################################################


def get_update_methods() -> Dict[str, Dict[str, str]]:
    """Get the value of `passthru.autoUpdate` for all packages."""
    return nix_eval(
        PACKAGES,
        "builtins.mapAttrs (_: x: if x ? passthru"
        "  then (if x.passthru ? autoUpdate then x.passthru.autoUpdate else null)"
        "  else null)",
    )


def get_package_file(pname: str) -> Optional[str]:
    """Return the file package `pname` is defined in. This uses `meta.position`
    and so it only works if the whole package is defined in the same file."""
    position = nix_eval(
        f'{PACKAGES}."{pname}"', "x: if x ? meta then x.meta.position else null"
    )
    if not position:
        return
    # Take the path part of the position, discard the line number.
    store_path = position.split(":")[0]
    # Strip the flake path from the location. If the store path does not start
    # with the path of this flake then the file is not part of this flake.
    if not store_path.startswith(f"{flake_path()}/"):
        return
    path = store_path[len(flake_path()) + 1 :]
    # Make sure that the parent directory is the same as `pname`. This is to
    # prevent e.g. wrappers which inherit `passthru.update` from being included.
    if path.startswith(f"{pname}/"):
        return path


def get_package_attr(pname: str, attr: str) -> str:
    """Return the value of `attr` in package `pname`."""
    return nix_eval(f'{PACKAGES}."{pname}".{attr}')


def set_package_attr(pname: str, attr: str, current_value: str, new_value: str) -> None:
    """Attempt to set the value of `attr` to `value` in package `pname`. This
    uses find/replace, so it only works on strings and will probably fail in
    really weird edge-cases."""
    package_file = get_package_file(pname)
    with open(package_file, "r") as file:
        source = file.read()
    # Ensure that there is exactly one occurrence of the current value.
    occurrences = source.count(f'"{current_value}"')
    if occurrences == 0:
        raise RuntimeError(f'string "{current_value}" not found in {package_file}')
    if occurrences > 1:
        raise RuntimeError(
            f'more than one instance of string "{current_value}" found in {package_file}'
        )
    # Do the replacement and save the file.
    with open(package_file, "w") as file:
        file.write(source.replace(f'"{current_value}"', f'"{new_value}"'))
    # Ensure that the updated value of `attr` matches.
    current_value = get_package_attr(pname, attr)
    if current_value != new_value:
        raise RuntimeError(
            'expected "{new_value}", got "{current_value}" for {attr} in {package_file}'
        )


################################################


def get_url_location(url: str, user_agent: str = "curl/7.76.1") -> str:
    """Follow redirects on `url` and return the final URL."""
    return urlopen(Request(url, headers={"User-Agent": user_agent})).geturl()


def get_url_hash(url: str) -> str:
    """Get the SRI hash of `url` using nix-prefetch-url."""
    sha256 = get_stdout(["nix-prefetch-url", "--unpack", url], stderr=DEVNULL).strip()
    return get_stdout(["nix", "hash", "to-sri", "--type", "sha256", sha256]).strip()


################################################


def tag_to_version(tag: str) -> str:
    """Remove any leading 'v' from a tag to get the version number."""
    if len(tag) >= 2 and tag[0].lower() == "v" and tag[1].isdigit():
        return tag[1:]
    return tag


def update_package_generic(
    pname: str, method: str, version: str, rev: str = None
) -> None:
    """Update package `pname` with a new `version`, `src.hash` (computed from
    `src_url`), and optionally a new `src.rev` (for packages whose rev does not
    depend on their version). This does nothing if `version` is the same as the
    current version."""
    current_version = get_package_attr(pname, "version")
    if current_version == version:
        print(f"package {pname} is already the latest version ({version})")
        return

    def print_change(name: str, old: str, new: str) -> None:
        print(f"{name}: {old} -> {new}")

    print_change(" version", current_version, version)
    set_package_attr(pname, "version", current_version, version)

    if rev:
        current_rev = get_package_attr(pname, "src.rev")
        assert (
            tag_to_version(current_rev) != version
        ), "rev cannot depend on version when using method git-commits!"
        print_change(" src.rev", current_rev, rev)
        set_package_attr(pname, "src.rev", current_rev, rev)

    current_hash = get_package_attr(pname, "src.outputHash")
    new_hash = get_url_hash(get_package_attr(pname, "src.url"))
    print_change("src.hash", current_hash, new_hash)
    set_package_attr(pname, "src.outputHash", current_hash, new_hash)

    set_output("pr-branch", f"{pname}-{version}")
    set_output("pr-title", f"{pname}: {current_version} -> {version}")
    set_output("pr-body", f"Automated update by update.py (method: {method}).")


################################################


def update_package_git_tags(pname: str) -> None:
    """Update package `pname` using the newest (sorted by name) git tag as the
    version."""
    remote_url = get_package_attr(pname, "src.meta.homepage")

    output = get_stdout(
        ["git", "ls-remote", "--tags", "--refs", "--sort=v:refname", remote_url]
    )

    latest_tag = output.strip().split("\n")[-1]  # Get last line
    latest_tag = latest_tag.split("\t")[1]  # Get 'refs/tags/…' part
    latest_tag = "/".join(latest_tag.split("/")[2:])  # Get tag name

    update_package_generic(pname, "git-tags", tag_to_version(latest_tag))


def update_package_git_commits(pname: str) -> None:
    """Update package `pname` using the date of the newest git commit as the
    version."""
    remote_url = get_package_attr(pname, "src.meta.homepage")

    with TemporaryDirectory(prefix="update.py-") as repo:
        get_stdout(["git", "clone", "--depth=1", remote_url, repo])
        output = get_stdout(
            ["git", "log", "-1", "--format=%H %at"],
            cwd=repo,
        ).strip()

    rev, epoch_time = output.split(" ")
    version = "unstable-" + strftime("%Y-%m-%d", gmtime(int(epoch_time)))
    update_package_generic(pname, "git-commits", version, rev)


def update_package_github_releases(pname: str) -> None:
    """Update package `pname` from its GitHub releases."""
    repo_url = get_package_attr(pname, "src.meta.homepage")
    releases_url = f"{repo_url.rstrip('/')}/releases/latest"
    latest_tag = get_url_location(releases_url).rstrip("/").split("/")[-1]
    update_package_generic(pname, "github-releases", tag_to_version(latest_tag))


################################################


def get_supported_packages():
    """Output the names of packages that support auto-updates."""
    supported = []
    print("```text")
    print("———— Packages supporting auto-updates ——————————————————————")
    for pname, method in get_update_methods().items():
        if not method:
            continue
        package_file = get_package_file(pname)
        if not package_file:
            continue
        print(f"- {pname} ({package_file}, method {method})")
        supported.append(pname)
    if not supported:
        print("  (none)")
    print("```")
    set_output("packages", supported)


################################################

if __name__ == "__main__":
    if argv[1] == "matrix":
        # Set the `packages` output to the list of packages that support
        # auto-updates, for use in the next step's matrix.
        get_supported_packages()
    elif argv[1] == "update":
        # Update package `pname` based on the value of its
        # `passthru.updateMethod` attr.
        pname = argv[2]
        method = get_update_methods()[pname]
        print("```text")
        print(f"updating package {pname} using method {method}...")
        update_fn = {
            "git-tags": update_package_git_tags,
            "git-commits": update_package_git_commits,
            "github-releases": update_package_github_releases,
        }[method]
        update_fn(pname)
        print("```")
