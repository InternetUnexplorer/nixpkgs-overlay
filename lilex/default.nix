{ stdenv, lib, fetchzip, writeShellScript, nix-update }:

let repository = "https://github.com/mishamyrt/Lilex";

in stdenv.mkDerivation rec {
  pname = "lilex";
  version = "2.510";

  src = fetchzip {
    url = "${repository}/releases/download/${version}/Lilex.zip";
    hash = "sha256-f0y+u6qlRl+DIvJPe/p0MqvNm0FVzDUQ2WyoAN6Ihqg=";
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
