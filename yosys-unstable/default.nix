{ yosys, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-10-26";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "672375ed02be68733856e616a5f4fbf281fe7733";
    hash = "sha256-MQs6eiFvl6Bta/PjUDdYPdPv7tsJtofZ14TVLHDvArc=";
  };

  inherit abc-verifier;

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  patches = [ ./plugin-search-dirs.patch ];

  passthru.updateScript = writeShellScript "update-yosys-unstable" ''
    set -e -u -o pipefail
    ${nix-update}/bin/nix-update --flake yosys-unstable --version branch
    YOSYS_SRC=$(nix build .#yosys-unstable.src --no-link --print-out-paths)
    ABCREV=$(awk '/^ABCREV/ {print $NF}' $YOSYS_SRC/Makefile)
    ${nix-update}/bin/nix-update --flake yosys-unstable.abc-verifier --version branch=$ABCREV
  '';
  passthru.exePath = "/bin/yosys";
})
