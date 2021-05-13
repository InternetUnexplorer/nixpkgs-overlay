final: prev:
let callPackagePrev = prev.lib.callPackageWith (prev);
in {
  ##
  ## New Packages
  ##
  breeze-enhanced = prev.callPackage ./breeze-enhanced { };
  breeze-mod-sddm-theme = prev.callPackage ./breeze-mod-sddm-theme { };
  gwe = prev.callPackage ./gwe { };
  lightly = prev.callPackage ./lightly { };
  lightly-shaders = prev.callPackage ./lightly-shaders { };
  luaformatter = prev.callPackage ./luaformatter { };
  nilium = prev.callPackage ./nilium { };
  oh-my-fish = prev.callPackage ./oh-my-fish { };
  plasma5-wallpapers-dynamic =
    prev.callPackage ./plasma5-wallpapers-dynamic { };
  reStream = prev.callPackage ./reStream { };

  ##
  ## Package Overrides
  ##
  inconsolata = callPackagePrev ./inconsolata { };
}
