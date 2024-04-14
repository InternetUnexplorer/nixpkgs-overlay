{ yosys, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "yosys-0.40-unstable-2024-04-13";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "b827b9862f16720d2bfb5aa204818f3d1530bef0";
    hash = "sha256-3XKMN0a7mCZ7R/QN6MteXgk0nWc/RfnijfE47UAN9GE=";
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

  # plugin-search-dirs.patch needs to be updated!
  meta = prev.meta // { broken = true; };
})
