{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-06-09";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "236e15f3b06fc4a05143399cf10b682996d5c509";
    hash = "sha256-V6VfWwsWLkceiV4Ch87ZUB/SiNVspOfdX+bQ8zqKmVY=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  patches = [ ./plugin-search-dirs.patch ];
})
