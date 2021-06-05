{ stdenv, fetchFromGitHub }:

let
  pname = "nilium";
  version = "4.0.2";
in stdenv.mkDerivation rec {
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

  meta = {
    description = "Nilium is a dark theme designed from scratch for Plasma 5";
    homepage = "https://github.com/mcder3/Nilium-Plasma-Theme/";
    license = "CC-BY-SA-4.0";
  };
}
