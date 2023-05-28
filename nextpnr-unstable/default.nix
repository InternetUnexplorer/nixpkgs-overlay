{ nextpnrWithGui, callPackage, fetchFromGitHub }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-05-25";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "e5a5de53c1e0146582742202e702e98748899b75";
    hash = "sha256-iAl7gytIFyR6IwmEuuKVVukFVmk2Hl07OMQ+il8kmvU=";
  };

  passthru = (prev.passthru or { }) // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
