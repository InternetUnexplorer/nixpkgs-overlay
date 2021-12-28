{ stdenv, lib, fetchFromGitHub, rustPlatform, pkg-config, glib, gtk3, dbus_tools
, help2man, wrapGAppsHook }:

let
  pname = "popsicle";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "714640582a0e1fcae46301ed2d3441bdc73dc823";
    hash = "sha256-PN4aAfuSpD1uEHdGSVa/OLnT2zb+dON7NftYL3BdjLE=";
  };
in stdenv.mkDerivation {
  inherit pname version src;

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-rPnO9AHFxdQWdmEhi5sUWpxoyNKQg7nSgxGoCTLnrdA=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    wrapGAppsHook
  ];

  buildInputs = [ glib gtk3 dbus_tools help2man ];

  dontConfigure = true;

  installPhase = "prefix=$out make install";

  passthru.exePath = "/bin/popsicle";

  meta = with lib; {
    description = " Multiple USB file flasher";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
