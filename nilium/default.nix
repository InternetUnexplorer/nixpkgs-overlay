{ stdenv, lib, fetchFromGitHub }:

let
  pname = "nilium";
  version = "4.0.2";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "InternetUnexplorer";
    repo = "Nilium-Plasma-Theme";
    rev = version;
    hash = "sha256-6mUfvj4WTq4vmkyx/jcFWAWt9FLdxONApz42XZibP5c=";
  };

  installPhase = ''
    cp -a Nilium $out/
  '';

  meta = with lib; {
    description = "Nilium is a dark theme designed from scratch for Plasma 5";
    inherit (src.meta) homepage;
    license = licenses.cc-by-sa-40;
    platforms = platforms.linux;
  };
}
