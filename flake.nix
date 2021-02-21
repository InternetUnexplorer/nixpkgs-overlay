{
  description = "InternetUnexplorer's nixpkgs overlays";
  outputs = { self }: { overlay = import ./default.nix; };
}
