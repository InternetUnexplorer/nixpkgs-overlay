{ stdenv, lib, fetchurl, pkg-config, pango, squeak, installShellFiles }:

let
  pname = "scratch";
  version = "1.4.0.7";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://download.scratch.mit.edu/${pname}-${version}.src.tar.gz";
    hash = "sha256-uU2JJ47O8rotEUfuwjk23ZlpcpP/osIWwKN1upgiaj4=";
  };

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ pkg-config pango squeak ];

  installPhase = ''
    runHook preInstall

    install -Dm755 src/scratch $out/bin/scratch
    install -Dm755 Scratch.image $out/lib/Scratch.image
    install -Dm755 Scratch.ini $out/lib/Scratch.ini

    install -Dm644 src/scratch.desktop $out/share/applications/scratch.desktop
    install -Dm644 src/scratch.xml $out/share/mime/packages/scratch.xml

    installManPage src/man/scratch.1.gz

    for size in $(ls src/icons); do
      install -Dm644 src/icons/$size/scratch.png \
        $out/share/icons/hicolor/$size/apps/scratch.png
    done

    cp -a Help Media Projects $out/share/
    cp -a Plugins $out/lib/

    runHook postInstall
  '';

  postFixup = ''
    # Scratch.image contains a bunch of references to /usr/share/scratch
    # but I haven't figured out how to fix that yet. :(

    sed -i -e '/^VM_VERSION=/d'                                    \
           -e "s|SQ_DIR=.*|SQ_DIR=$(echo ${squeak}/lib/squeak/*)|" \
           -e "s|/usr/lib/scratch|$out/lib|g"                      \
           -e 's|-vm-sound-ALSA|-vm-sound-pulse|'                  \
           $out/bin/scratch
  '';

  meta = with lib; {
    description =
      "Create and share your own interactive stories, games, music and art";
    homepage = "https://scratch.mit.edu";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
