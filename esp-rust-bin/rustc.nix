{ lib, stdenv, autoPatchelfHook, gcc, zlib, darwin, src, version, meta, platform
}:

stdenv.mkDerivation {
  inherit src version meta;

  pname = "esp-rustc-bin";

  nativeBuildInputs = lib.optional (!stdenv.isDarwin) autoPatchelfHook;
  buildInputs = lib.optionals (!stdenv.isDarwin) [ gcc.cc.lib zlib ]
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  postPatch = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall
    ./install.sh --prefix=$out --components=rustc,rust-std-${platform}
    runHook postInstall
  '';

  dontStrip = stdenv.isDarwin;
}
