{ stdenv, lib, fetchFromGitLab, fetchpatch, extra-cmake-modules, plasma5Packages
, writeShellScript, nix-update }:

stdenv.mkDerivation rec {
  pname = "plasma-applet-thermal-monitor";
  version = "1.3.0-unstable-2023-08-28";

  src = fetchFromGitLab {
    owner = "agurenko";
    repo = "plasma-applet-thermal-monitor";
    rev = "438f829d4e5ebfa45247935713ad46643fdd3c39";
    hash = "sha256-ywxw+3+MvMYjKTw+nXy161CciURHWxuNYbRXgX9d7XE=";
  };

  nativeBuildInputs = [ extra-cmake-modules plasma5Packages.wrapQtAppsHook ];

  buildInputs = [ plasma5Packages.plasma-workspace ];

  meta = with lib; {
    description =
      "Plasma 5 applet for monitoring CPU, GPU and other available temperature sensors";
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

  passthru.updateScript = writeShellScript "update-${pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${pname} --version branch
  '';
}
