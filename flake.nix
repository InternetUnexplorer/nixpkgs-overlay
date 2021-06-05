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

      packages.x86_64-linux = {
        inherit (pkgs)
          breeze-enhanced gwe lightly lightly-shaders luaformatter nilium
          plasma5-wallpapers-dynamic reStream;
      };
    };
}
