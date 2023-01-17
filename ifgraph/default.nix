{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ifgraph";
  version = "unstable-2023-01-17";

  src = fetchFromGitHub {
    owner = "stolk";
    repo = "ifgraph";
    rev = "43869ff5b730edd8e41e8ac42dc59b8a6f708674";
    hash = "sha256-wUvTx16hvrLViuOHPZO1jDSm4zgiH+D1sPMSByGXJUY=";
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
