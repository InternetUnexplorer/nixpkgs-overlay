{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ifgraph";
  version = "unstable-2023-02-16";

  src = fetchFromGitHub {
    owner = "stolk";
    repo = "ifgraph";
    rev = "32d1ccc28bac70ce74d0bf271409f5e9f4c944a3";
    hash = "sha256-KceNco06xG6iL7aTZruokYS8nfHyq+ndqjpOHEk1sBc=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace '/usr/bin' '/bin'
  '';

  installPhase = ''
    runHook preInstall
    make install DESTDIR=$out
    runHook postInstall
  '';

  passthru.autoUpdate = "git-commits";

  meta = with lib; {
    description = "Network interface grapher";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
