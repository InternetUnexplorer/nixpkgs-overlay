{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-03-11";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "101d19bb6aef187653e240f5c6859e4d2efde1b5";
    hash = "sha256-u5ONDmtjZAFj5ELp4TdTtLMnt9D0MYoh4QyOkjLdNZk=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
