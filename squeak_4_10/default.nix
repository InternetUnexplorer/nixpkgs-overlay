{ callPackage, xorg }:

callPackage ./squeak_4_10.nix { inherit (xorg) libpthreadstubs; }
