{ stdenv, lib, fetchFromGitHub }:

let
  pname = "capitaine-cursors-bin";
  version = "3";
  src = fetchFromGitHub {
    owner = "keeferrourke";
    repo = "capitaine-cursors";
    rev = "r${version}";
    hash = "sha256-u72yHbVivdn0Rm2Gvz80ZiQKC2ZyMbN9vmjbZHNdzl4=";
  };
in stdenv.mkDerivation {
  inherit pname version src;

  installPhase = ''
    mkdir -pm 0755 $out/share/icons
    cp -pr dist $out/share/icons/capitaine-cursors
    cp -pr dist-white $out/share/icons/capitaine-cursors-white
  '';

  meta = with lib; {
    description = "An x-cursor theme inspired by macOS and based on KDE Breeze";
    inherit (src.meta) homepage;
    license = licenses.lgpl3;
    platforms = platforms.linux;
  };
}
