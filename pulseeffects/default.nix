{ pkgs }:

pkgs.callPackage ./pulseeffects.nix { boost = pkgs.boost172; }
