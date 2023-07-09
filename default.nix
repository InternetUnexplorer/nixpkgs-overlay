final: prev:

import ./all-packages.nix {
  inherit (prev) lib;
  callPackage = prev.lib.callPackageWith prev;
}
