{ nextpnrWithGui, callPackage, fetchFromGitHub }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-03-17";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "e4fcd3740dd8a650922903db6e15f4eaff25b5ee";
    hash = "sha256-bVyjM73uKiuIBCj6VhLdiCcn0+sbbqhiuWMQecNr/TY=";
  };

  passthru = (prev.passthru or { }) // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
