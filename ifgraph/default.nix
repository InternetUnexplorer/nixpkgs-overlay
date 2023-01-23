{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ifgraph";
  version = "unstable-2023-01-21";

  src = fetchFromGitHub {
    owner = "stolk";
    repo = "ifgraph";
    rev = "51cd0276cde0f03b6a428bdda838c336b268bbf4";
    hash = "sha256-4yZMP8IQpD5ocUN/rxQk9WbAKVF7s2gWg8f1Q5SQRHM=";
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
