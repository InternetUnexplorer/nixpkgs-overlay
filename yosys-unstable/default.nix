{ yosys, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-09-07";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "41b34a19353dbbe00aa08f3561e25e0bfa4c84d2";
    hash = "sha256-ZdhIrM+9rGNCBeVyxaGDUUPQopCpx1tJ/pP3Xef507A=";
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
