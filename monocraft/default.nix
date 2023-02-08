{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "monocraft";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "IdreesInc";
    repo = "Monocraft";
    rev = "v${version}";
    hash = "sha256-Ya4sizRy9nXMVBCNs4Zi83yXa855hwBXICppJesnhwA=";
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
