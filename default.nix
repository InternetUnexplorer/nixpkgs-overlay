self: super:
let callPackageSuper = super.lib.callPackageWith (super);
in {
  ##
  ## New Packages
  ##
  breeze-enhanced = super.callPackage ./breeze-enhanced { };
  breeze-modified-sddm-theme =
    super.callPackage ./breeze-modified-sddm-theme { };
  gwe = super.callPackage ./gwe { };
  nilium = super.callPackage ./nilium { };

  ##
  ## Package Overrides
  ##
  blender = callPackageSuper ./blender { };
  capitaine-cursors = callPackageSuper ./capitaine-cursors { };
  openrgb = callPackageSuper ./openrgb { };
  plasma5 = super.plasma5 // { kwin = callPackageSuper ./kwin { }; };
}
