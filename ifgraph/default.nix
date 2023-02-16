{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ifgraph";
  version = "unstable-2023-02-15";

  src = fetchFromGitHub {
    owner = "stolk";
    repo = "ifgraph";
    rev = "d55df7bcb5fd37eb81bfa40df44356f7b3784864";
    hash = "sha256-61a82kXtX1ccLx53LIwDmneqO2usQdhgLQkRkRmOprI=";
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
