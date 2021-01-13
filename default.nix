self: super:
let callPackageSuper = super.lib.callPackageWith (super);
in {
  ##
  ## New Packages
  ##
  breeze-enhanced = super.callPackage ./breeze-enhanced { };
  breeze-mod-sddm-theme = super.callPackage ./breeze-mod-sddm-theme { };
  gwe = super.callPackage ./gwe { };
  luaformatter = super.callPackage ./luaformatter { };
  nilium = super.callPackage ./nilium { };
  oh-my-fish = super.callPackage ./oh-my-fish { };

  ##
  ## Package Overrides
  ##
  capitaine-cursors = callPackageSuper ./capitaine-cursors { };
  inconsolata = callPackageSuper ./inconsolata { };
  multimc = callPackageSuper ./multimc { };
  picom = callPackageSuper ./picom { };
}
