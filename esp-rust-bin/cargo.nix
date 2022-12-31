{ lib, stdenv, makeWrapper, autoPatchelfHook, gcc, darwin, src, version, meta
, rustc }:

stdenv.mkDerivation {
  inherit src version meta;

  pname = "esp-cargo-bin";

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional (!stdenv.isDarwin) autoPatchelfHook;
  buildInputs = lib.optional (!stdenv.isDarwin) gcc.cc.lib
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  postPatch = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall
    ./install.sh --prefix=$out --components=cargo
    wrapProgram $out/bin/cargo --prefix PATH : "${rustc}/bin"
    runHook postInstall
  '';
}
