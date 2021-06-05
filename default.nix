final: prev:

let packages = import ./packages.nix { inherit (prev) lib; };
in prev.lib.genAttrs packages
(name: prev.lib.callPackageWith prev (./. + "/${name}") { })
