{ yosys, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2024-02-11";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "ac0fb2e301188178ea691f2ef156d0af6f4f967f";
    hash = "sha256-/FVKPChn8QsByfCeMjop1HDeJSNohgKuaXFLoHIa7/U=";
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
