final: prev:
let callPackagePrev = prev.lib.callPackageWith (prev);
in {
  ##
  ## New Packages
  ##
  breeze-enhanced = prev.callPackage ./breeze-enhanced { };
  gwe = prev.callPackage ./gwe { };
  lightly = prev.callPackage ./lightly { };
  lightly-shaders = prev.callPackage ./lightly-shaders { };
  luaformatter = prev.callPackage ./luaformatter { };
  nilium = prev.callPackage ./nilium { };
  plasma5-wallpapers-dynamic =
    prev.callPackage ./plasma5-wallpapers-dynamic { };
  reStream = prev.callPackage ./reStream { };
}
