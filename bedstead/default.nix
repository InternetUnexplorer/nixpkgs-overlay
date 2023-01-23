{ stdenvNoCC, lib, fetchzip }:

let homepage = "https://bjh21.me.uk/bedstead";

in stdenvNoCC.mkDerivation rec {
  pname = "bedstead";
  version = "002.004";

  src = fetchzip {
    url = "${homepage}/bedstead-${version}.zip";
    hash = "sha256-d7QH4/GhVQGqigveEpQOQO55sA5eV6Lij2qB8kZhXic=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    for font in *.otf; do
      install -Dm644 "$font" $out/share/fonts/opentype/"$font"
    done
    runHook postInstall
  '';

  meta = with lib; {
    description =
      "A family of outline fonts based on the characters produced by the Mullard SAA5050 series of Teletext Character Generators";
    inherit homepage;
    license = licenses.publicDomain;
    platforms = platforms.all;
  };
}
