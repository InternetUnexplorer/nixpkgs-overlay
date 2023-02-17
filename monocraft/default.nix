{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "monocraft";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "IdreesInc";
    repo = "Monocraft";
    rev = "v${version}";
    hash = "sha256-oKi7KK2JvUGoXuKei64PaLMz7NlzXcfXFLhZ1ScFI5k=";
    sparseCheckout = [ "/" ];
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 Monocraft.otf $out/share/fonts/opentype/Monocraft.otf
    runHook postInstall
  '';

  # TODO: Fix auto-update when src.url is not a tarball
  passthru.autoUpdate = "github-releases";

  meta = with lib; {
    description = "A programming font based on the typeface used in Minecraft";
    inherit (src.meta) homepage;
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
