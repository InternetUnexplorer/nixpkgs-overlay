{ nextpnrWithGui, callPackage, fetchFromGitHub }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-06-09";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "5b958c4d80e791d924c80bca48a1c41a8037e1d8";
    hash = "sha256-bH27t8JUFcH4gcEu/sPt9CNYeWJO0mDgOhM6qq5CXtU=";
  };

  passthru = (prev.passthru or { }) // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
