{
  description = "InternetUnexplorer's nixpkgs overlays";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  nixConfig = {
    extra-substituters = "https://internetunexplorer.cachix.org";
    extra-trusted-public-keys =
      "internetunexplorer.cachix.org-1:F6CYMkx5/TJmDQQ+DTsFzRy58Ad+doYEW5CdVDZJVdY=";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };

        isSupported = _: drv: builtins.elem system drv.meta.platforms;
        packages = pkgs.lib.filterAttrs isSupported
          (pkgs.lib.genAttrs (import ./packages.nix { inherit (pkgs) lib; })
            (name: pkgs.${name}));

        isApp = _: drv: pkgs.lib.hasAttrByPath [ "passthru" "exePath" ] drv;
        apps =
          pkgs.lib.mapAttrs (_: drv: flake-utils.lib.mkApp { inherit drv; })
          (pkgs.lib.filterAttrs isApp packages);

      in { inherit apps packages; }

    ) // {
      overlays.default = import ./default.nix;
    };
}
