{ stdenvNoCC, lib, fetchFromGitHub }:

let
  pname = "nilium";
  version = "4.2.0";
in stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "InternetUnexplorer";
    repo = "Nilium-Plasma-Theme";
    rev = version;
    hash = "sha256-LMfaGQ2tLIGMtQxi6+4/YtjD6UxW15GDFcXJZzEkeYI=";
  };

  installPhase = ''
    mkdir -p $out/share/plasma/desktoptheme
    cp -r Nilium $out/share/plasma/desktoptheme
  '';

  meta = with lib; {
    description = "A dark theme designed from scratch for Plasma 5";
    homepage = "https://store.kde.org/p/1226329";
    license = licenses.cc-by-sa-40;
    platforms = platforms.linux;
  };
}
