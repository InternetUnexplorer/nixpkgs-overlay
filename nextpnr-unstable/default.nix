{ nextpnrWithGui, callPackage, fetchFromGitHub }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-03-22";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "b36e8a3013ac70a9fbe71d2163f660dafe3b8b2f";
    hash = "sha256-8U6emILwRFoxD5BuZL6SrtoJmZLZ3Lzi+PFvvWvmiew=";
  };

  passthru = (prev.passthru or { }) // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
