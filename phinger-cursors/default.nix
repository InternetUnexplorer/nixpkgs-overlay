{ stdenvNoCC, lib, fetchurl }:

let
  pname = "phinger-cursors";
  version = "1.1";
  repo = "https://github.com/phisch/phinger-cursors";
in stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "${repo}/releases/download/v${version}/${pname}-variants.tar.bz2";
    hash = "sha256-II+1x+rcjGRRVB8GYkVwkKVHNHcNaBKRb6C613901oc=";
  };

  sourceRoot = ".";

  installPhase = ''
    install -Ddm755 "$out/share/icons"
    for dir in $(find . -mindepth 1 -maxdepth 1 -type d); do
        cp -dr --no-preserve=ownership "$dir" "$out/share/icons/"
    done
  '';

  meta = with lib; {
    description = "Most likely the most over-engineered cursor theme";
    homepage = repo;
    license = licenses.cc-by-sa-40;
    platforms = platforms.linux;
  };
}
