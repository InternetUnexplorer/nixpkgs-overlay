{ stdenv, lib, fetchurl, pkg-config, hidapi, libusb }:

let repo = "https://github.com/wuxx/icesugar";

in stdenv.mkDerivation rec {
  pname = "icesprog";
  version = "1.1b";

  src = fetchurl {
    url = "${repo}/raw/v${version}/tools/src/icesprog.c";
    hash = "sha256-LiaTFxT3+qH+iBDCqCwyMc21ttdcib6939C05IOze5w=";
  };

  buildInputs = [ hidapi libusb ];
  nativeBuildInputs = [ pkg-config ];

  unpackPhase = ''
    runHook preUnpack

    cp $src icesprog.c

    runHook postUnpack
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    # https://github.com/wuxx/icesugar/blob/v1.1b/tools/src/Makefile
    LIBUSB=libusb-1.0
    HIDAPI=hidapi-hidraw
    cc icesprog.c -o icesprog                   \
      -std=c99 -Wall -Wextra -Wno-unused-result \
      -D_POSIX_C_SOURCE=200112L                 \
      -D_BSD_SOURCE -D_DEFAULT_SOURCE           \
      $(pkg-config --cflags $LIBUSB)            \
      $(pkg-config --cflags $HIDAPI)            \
      $(pkg-config --libs $LIBUSB)              \
      $(pkg-config --libs $HIDAPI)

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 icesprog $out/bin/icesprog

    runHook postInstall
  '';

  passthru.exePath = "/bin/icesprog";

  meta = with lib; {
    description = "A programmer for the iCESugar FPGA boards";
    homepage = repo;
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ]; # TODO
  };
}
