{
  description = "InternetUnexplorer's nixpkgs overlays";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };

        packages =
          pkgs.lib.genAttrs (import ./packages.nix { inherit (pkgs) lib; })
          (name: pkgs.${name});

        isApp = _: drv: pkgs.lib.hasAttrByPath [ "passthru" "exePath" ] drv;
        apps =
          pkgs.lib.mapAttrs (_: drv: flake-utils.lib.mkApp { inherit drv; })
          (pkgs.lib.filterAttrs isApp packages);

      in { inherit apps packages; }

    ) // {
      overlay = import ./default.nix;
    };
}
