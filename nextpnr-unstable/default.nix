{ nextpnrWithGui, callPackage, fetchFromGitHub }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-04-14";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "71192dc7a3b8dfae1f76f48412dd906bfb0783e7";
    hash = "sha256-QzKWcajJJBjoqWRweOy9W4JZ3q5w+Bl+ixBs3NLLOZ0=";
  };

  passthru = (prev.passthru or { }) // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
