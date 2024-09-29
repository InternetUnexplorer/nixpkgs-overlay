{ stdenv, lib, fetchzip, writeShellScript, nix-update }:

let repository = "https://github.com/mishamyrt/Lilex";

in stdenv.mkDerivation rec {
  pname = "lilex";
  version = "2.600";

  src = fetchzip {
    url = "${repository}/releases/download/${version}/Lilex.zip";
    hash = "sha256-vmXityBoSquGfvEXn1Iohq4Skojbfm48+PrzR12ZYMw=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/truetype ttf/*.ttf
    runHook postInstall
  '';

  meta = with lib; {
    description = "Open source programming font";
    homepage = repository;
    license = licenses.ofl;
    platforms = platforms.all;
  };

  passthru.updateScript = writeShellScript "update-${pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${pname}
  '';
}
