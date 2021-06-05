{
  description = "InternetUnexplorer's nixpkgs overlays";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ self.overlay ];
      };
    in {
      overlay = import ./default.nix;
      packages.x86_64-linux =
        pkgs.lib.genAttrs (import ./packages.nix { inherit (pkgs) lib; })
        (name: pkgs.${name});
    };
}
