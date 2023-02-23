{ nextpnr, callPackage, fetchFromGitHub }:

nextpnr.overrideAttrs (final: prev: {
  version = "unstable-2023-02-23";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "ebbaf8c08dbde251aa4f2809f296b20a7a2266a8";
    hash = "sha256-GxBLgAJ8i0AvuRRJPVvSqpNnDdnKf8Z6BNjkQBzuVW0=";
  };

  passthru = (prev.passthru or { }) // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
