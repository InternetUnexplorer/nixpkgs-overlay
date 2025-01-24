{ nextpnrWithGui, fetchFromGitHub, lib, fetchpatch }:

let
  fix-gowin-gui = fetchpatch {
    url = let commit = "e4c09a1011f2df9b77f9360f14f58af6ab1f5e1c";
    in "https://github.com/YosysHQ/nextpnr/commit/${commit}.patch";
    sha256 = "sha256-LSQ+1tDf8L47W+s9T0iT8iGU/Yu6xdO7bji94fBEHA0=";
  };
in nextpnrWithGui.overrideAttrs (old: {
  version = "unstable-2025-01-23";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "0c060512c1bf6719391e2d3351c8cb757bec29cc";
    sha256 = "sha256-BLNu84riTL/Wg6y/XuxKjvq5G4EUY5gVC4t717yzSgg=";
  };

  patches = (old.patches or [ ]) ++ [ fix-gowin-gui ];
})
