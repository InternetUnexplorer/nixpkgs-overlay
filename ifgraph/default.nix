{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ifgraph";
  version = "unstable-2023-01-29";

  src = fetchFromGitHub {
    owner = "stolk";
    repo = "ifgraph";
    rev = "e4d69ee482200f3f3e382ec3f2645a666b1856a4";
    hash = "sha256-v49TetJwkVv+XzCGJ+1A7ADszT/SQj9CRNq7iX3mCrk=";
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
