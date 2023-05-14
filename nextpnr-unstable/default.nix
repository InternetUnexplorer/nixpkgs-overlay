{ nextpnrWithGui, callPackage, fetchFromGitHub }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-04-20";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "57b923a6031f28f5d5a2c48d733cd86a3bcf2737";
    hash = "sha256-dv4WR1Ux/gL57gD0f3ZWCrqhB/6ZVDgPN9PiMOxnaAw=";
  };

  passthru = (prev.passthru or { }) // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
