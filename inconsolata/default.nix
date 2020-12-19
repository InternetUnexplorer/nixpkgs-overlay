{ inconsolata, fetchFromGitHub }:

inconsolata.overrideAttrs (old: rec {
  version = "3.000";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "inconsolata";
    rev = "v${version}";
    sha256 = "17gr7bvm46pal4mvwmh1mm899sj1hp7i0scr1nf6sx1y05kk74v6";
  };

  installPhase = ''
    install -m644 --target $out/share/fonts/truetype/inconsolata -D ./fonts/ttf/*.ttf
  '';
})
