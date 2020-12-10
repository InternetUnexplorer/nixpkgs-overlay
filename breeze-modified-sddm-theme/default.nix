{ stdenv, fetchurl }:

let
  background = fetchurl {
    url =
      "https://www.hdwallpapers.in/download/minimal_blue_mountains_hd_5k-wide.jpg";
    hash = "sha256-5z712Fo5wRl0RoKYLcZr4afYim6XtisS5OoAxKNdrSM=";
  };

  plasma-srcs = import <nixpkgs/pkgs/desktops/plasma-5/srcs.nix> {
    inherit fetchurl;
    mirror = "mirror://kde";
  };

in stdenv.mkDerivation rec {
  pname = "breeze-modified";
  version = plasma-srcs.plasma-workspace.version;
  src = plasma-srcs.plasma-workspace.src;

  patchPhase = ''
    mv sddm-theme/theme.conf.cmake sddm-theme/theme.conf
    substituteInPlace sddm-theme/theme.conf --replace \
      'background=''${KDE_INSTALL_FULL_WALLPAPERDIR}/Next/contents/images/5120x2880.jpg' \
      'background=${background}'
  '';

  buildPhase = ''
    rm sddm-theme/components
    cp -a lookandfeel/contents/components sddm-theme
  '';

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -a sddm-theme $out/share/sddm/themes/breeze-modified
  '';
}
