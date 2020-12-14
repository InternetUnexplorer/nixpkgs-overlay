{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nilium";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "mcder3";
    repo = "Nilium-Plasma-Theme";
    rev = "5eafeaffaa03a1688732185b8905ad51d59b985f";
    sha256 = "0cksv5d81cgyp6b8wbpf7jm3mpxrlkf96mmb2v48536jpvrxb6bv";
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
