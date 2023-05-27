{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-05-18";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "147cceb516552f2f9f989508bcdd57ae04621254";
    hash = "sha256-zRQks1DVgbuKNlyHeIvlWad+AMTgCS5qGLD5Pvo7mGo=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  patches = [ ./plugin-search-dirs.patch ];

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
