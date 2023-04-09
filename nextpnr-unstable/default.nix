{ nextpnrWithGui, callPackage, fetchFromGitHub }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-04-05";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "9bcefe46a89a1fb55ab86f2e0a3319baf1b92807";
    hash = "sha256-gMCAYLZ61zkSSShAzbk8RVSXAF6Kfzptu7VT4Er9YZc=";
  };

  passthru = (prev.passthru or { }) // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
