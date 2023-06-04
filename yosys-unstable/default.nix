{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-06-04";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "88c849d112f4f8cf20617bbc98eac055956269c2";
    hash = "sha256-0ncWF2FB/3FIoeXxhiTS7ol30LcWlA6+Yyfr6m/ygW0=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  patches = [ ./plugin-search-dirs.patch ];

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
