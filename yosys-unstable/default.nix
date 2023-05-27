{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-05-26";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "8596c5ce4915d1727d93df45fc58047f08886b41";
    hash = "sha256-Zn1U03vmBss8sqTeDNxbq+ofnyTWHHYUyxNmoslaOtg=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  patches = [ ./plugin-search-dirs.patch ];

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
