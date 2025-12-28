{ stdenv, lib, fetchFromGitHub, extra-cmake-modules, plasma5Packages, libavif
, libexif, writeShellScript, nix-update }:

stdenv.mkDerivation rec {
  pname = "plasma5-wallpapers-dynamic";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "zzag";
    repo = "plasma5-wallpapers-dynamic";
    rev = version;
    hash = "sha256-2MLrZ66VF6o1x191aoyvvnBzQnJAPVG1u4dqac5XXIk=";
  };

  nativeBuildInputs = [ extra-cmake-modules plasma5Packages.wrapQtAppsHook ];

  buildInputs = with plasma5Packages; [
    plasma-framework
    qtbase
    qtdeclarative
    qtlocation
    libavif
    libexif
  ];

  meta = with lib; {
    description = "Dynamic wallpaper plugin for KDE Plasma";
    inherit (src.meta) homepage;
    license = with licenses; [ bsd3 cc-by-sa-40 cc0 gpl3Plus lgpl3Plus ];
    platforms = platforms.linux;
    broken = true;
  };

  passthru.updateScript = writeShellScript "update-${pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${pname}
  '';
}
