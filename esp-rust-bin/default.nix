{ stdenv, lib, fetchurl, fetchzip, autoPatchelfHook, gcc, zlib, darwin
, writeShellScript, gh, jq }:

# NOTE: This is a work-in-progress

let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);

  platforms = {
    aarch64-darwin = "aarch64-apple-darwin";
    aarch64-linux = "aarch64-unknown-linux-gnu";
    x86_64-darwin = "x86_64-apple-darwin";
    x86_64-linux = "x86_64-unknown-linux-gnu";
  };

  platform = platforms.${stdenv.system};

in stdenv.mkDerivation rec {
  pname = "esp-rust-bin";
  inherit (sources) version;

  srcs = [
    (fetchurl rec {
      name = "rust-${version}-${platform}.tar.xz";
      inherit (sources.${name}) url hash;
    })
    (fetchurl rec {
      name = "rust-src-${version}.tar.xz";
      inherit (sources.${name}) url hash;
    })
  ];

  sourceRoot = ".";

  nativeBuildInputs = lib.optional (!stdenv.isDarwin) autoPatchelfHook;
  buildInputs = lib.optionals (!stdenv.isDarwin) [ gcc.cc.lib zlib ]
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  postPatch = ''
    patchShebangs */install.sh
  '';

  installPhase = ''
    runHook preInstall
    rust-*-${platform}/install.sh --destdir=$out --prefix="" \
      --components=rustc,rust-std-${platform},cargo
    rust-src-*/install.sh --destdir=$out --prefix="" \
      --components=rust-src
    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "update-${pname}" ''
    set -euo pipefail

    export PATH="${lib.makeBinPath [ gh jq ]}:$PATH"

    REPOSITORY=$(nix eval --raw .#$1.meta.homepage)
    RELEASE_JSON=$(gh release view --repo "$REPOSITORY" --json tagName,assets)

    VERSION=$(nix eval --raw .#$1.version)
    echo "current version is '$VERSION'"

    LATEST_VERSION=$(echo "$RELEASE_JSON" | jq -r '.tagName | sub("^v"; "")')
    if [ "$VERSION" == "$LATEST_VERSION" ]; then
        echo "up-to-date"
        exit 0
    fi

    echo "updating $1: $VERSION -> $LATEST_VERSION"
    SOURCES=$(jq -n '{"version": $version}' --arg version "$LATEST_VERSION")

    while read -r NAME URL; do
        [[ $NAME == *.tar.xz ]] || continue
        echo "downloading '$URL'..."
        HASH=$(nix store prefetch-file "$URL" --hash-type sha256 --json | jq -r .hash)
        SOURCES=$(echo "$SOURCES" | jq '.[$name] = {url: $url, hash: $hash}' \
                  --arg name "$NAME" --arg url "$URL" --arg hash "$HASH")
    done <<< "$(echo "$RELEASE_JSON" | jq -r '.assets[] | "\(.name) \(.url)"')"

    echo "$SOURCES" > "$1/sources.json"
  '';

  meta = with lib; {
    description =
      "Pre-built binaries of the Rust compiler fork with Xtensa support";
    homepage = "https://github.com/esp-rs/rust-build";
    license = [ licenses.afl20 licenses.mit ];
    platforms = builtins.attrNames platforms;
  };
}
