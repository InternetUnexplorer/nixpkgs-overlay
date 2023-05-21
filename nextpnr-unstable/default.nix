{ nextpnrWithGui, callPackage, fetchFromGitHub }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-05-19";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "1d3e5151ba5ccbb344e04b7024d4d270cb4acfba";
    hash = "sha256-yhEb/KDj1O8V4wAHsqgBj4Zg21VGICWkSZzI9lP2jOA=";
  };

  passthru = (prev.passthru or { }) // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
