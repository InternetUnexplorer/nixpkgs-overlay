{ stdenv, lib, fetchFromGitHub, writeShellScript, nix-update }:

stdenv.mkDerivation rec {
  pname = "ifgraph";
  version = "0-unstable-2025-05-25";

  src = fetchFromGitHub {
    owner = "stolk";
    repo = "ifgraph";
    rev = "c8ec77496cc209dca1dbb1a8315d14e21836c1f6";
    hash = "sha256-VACpY+VhbnJbRb4cmptxqYM/MhdmWQMNahf0Hbvm72w=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace '/usr/bin' '/bin'
  '';

  installPhase = ''
    runHook preInstall
    make install DESTDIR=$out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Network interface grapher";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
  };

  passthru.updateScript = writeShellScript "update-${pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${pname} --version branch
  '';
  passthru.exePath = "/bin/ifgraph";
}
