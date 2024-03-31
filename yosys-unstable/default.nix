{ yosys, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "yosys-0.39-unstable-2024-03-31";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "b9d3bffda5abcbc5356936a7192c4a3c2b427c3e";
    hash = "sha256-O23npMTKMULAr+H1Ty8jtwYNMm37/Waki06AE7BsATk=";
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
