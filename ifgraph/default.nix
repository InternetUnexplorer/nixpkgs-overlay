{ stdenv, lib, fetchFromGitHub, writeShellScript, nix-update }:

stdenv.mkDerivation rec {
  pname = "ifgraph";
  version = "unstable-2023-09-10";

  src = fetchFromGitHub {
    owner = "stolk";
    repo = "ifgraph";
    rev = "0f6d42bf7c2cebbcc4a8e7feaf70390e7004f4b6";
    hash = "sha256-6NG9ICS3tsn6MViB3IN3ukYcLZsY+vb3k9UYFSTAqjc=";
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
