{ nextpnrWithGui, fetchpatch }:

let
  fix-gowin-gui = fetchpatch {
    url = let commit = "e4c09a1011f2df9b77f9360f14f58af6ab1f5e1c";
    in "https://github.com/YosysHQ/nextpnr/commit/${commit}.patch";
    sha256 = "sha256-LSQ+1tDf8L47W+s9T0iT8iGU/Yu6xdO7bji94fBEHA0=";
  };
in nextpnrWithGui.overrideAttrs
(old: { patches = (old.patches or [ ]) ++ [ fix-gowin-gui ]; })
