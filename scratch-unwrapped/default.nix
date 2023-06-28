{ stdenv, lib, callPackage, fetchurl, pkg-config, pango, installShellFiles }:

let
  pname = "scratch-unwrapped";
  version = "1.4.0.7";
  squeak = callPackage ../squeak_4_10 { };
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://download.scratch.mit.edu/scratch-${version}.src.tar.gz";
    hash = "sha256-uU2JJ47O8rotEUfuwjk23ZlpcpP/osIWwKN1upgiaj4=";
  };

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ pkg-config pango squeak ];

  installPhase = ''
    runHook preInstall

    install -Dm755 src/scratch $out/bin/scratch
    install -Dm755 Scratch.image $out/lib/scratch/Scratch.image
    install -Dm755 Scratch.ini $out/lib/scratch/Scratch.ini

    install -Dm644 src/scratch.desktop $out/share/applications/scratch.desktop
    install -Dm644 src/scratch.xml $out/share/mime/packages/scratch.xml

    installManPage src/man/scratch.1.gz

    for size in $(ls src/icons); do
      install -Dm644 src/icons/$size/scratch.png \
        $out/share/icons/hicolor/$size/apps/scratch.png
    done

    mkdir -p $out/share/scratch
    cp -a Help Media Projects $out/share/scratch
    cp -a Plugins $out/lib/scratch

    runHook postInstall
  '';

  postFixup = ''
    sed -i -e '/^VM_VERSION=/d'                                    \
           -e "s|SQ_DIR=.*|SQ_DIR=$(echo ${squeak}/lib/squeak/*)|" \
           -e "s|/usr/lib/scratch|$out/lib/scratch|g"              \
           -e 's|-vm-sound-ALSA|-vm-sound-pulse|'                  \
           -e 's|-xshm||'                                          \
           $out/bin/scratch
  '';

  meta = with lib; {
    description =
      "Create and share your own interactive stories, games, music and art";
    homepage = "https://scratch.mit.edu";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

  passthru.exePath = "/bin/scratch";
}
