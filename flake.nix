{
  description = "A small overlay with some packages I use";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  nixConfig = {
    extra-substituters = "https://internetunexplorer.cachix.org";
    extra-trusted-public-keys =
      "internetunexplorer.cachix.org-1:F6CYMkx5/TJmDQQ+DTsFzRy58Ad+doYEW5CdVDZJVdY=";
  };

  outputs = { self, nixpkgs }:
    let
      allSystems = nixpkgs.lib.systems.flakeExposed;
      forAllSystems = nixpkgs.lib.genAttrs allSystems;
    in {
      packages = forAllSystems (system:
        let
          allPackages = import ./all-packages.nix {
            inherit (nixpkgs.legacyPackages.${system}) lib callPackage;
          };
          isSupported = _: package:
            nixpkgs.lib.elem system package.meta.platforms;
        in nixpkgs.lib.filterAttrs isSupported allPackages);

      apps = forAllSystems (system:
        let
          isApp = _: nixpkgs.lib.hasAttrByPath [ "passthru" "exePath" ];
          mkApp = _: package: {
            type = "app";
            program = "${package}${package.passthru.exePath}";
          };
        in nixpkgs.lib.mapAttrs mkApp
        (nixpkgs.lib.filterAttrs isApp self.packages.${system}));

      overlays.default = import ./default.nix;

      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
