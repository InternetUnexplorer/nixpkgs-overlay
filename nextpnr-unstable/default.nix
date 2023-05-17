{ nextpnrWithGui, callPackage, fetchFromGitHub }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-05-16";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "bc7b8b63ed6c8e855ca0256a2fde2b8c5885fd79";
    hash = "sha256-R3375BG89wKslkuXelgTKIETRVcZTxk3K4F4SdAeX1s=";
  };

  passthru = (prev.passthru or { }) // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
