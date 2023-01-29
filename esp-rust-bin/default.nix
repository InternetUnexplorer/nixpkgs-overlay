{ stdenv, lib, fetchurl, fetchzip, autoPatchelfHook, gcc, zlib, darwin }:

# NOTE: This is a work-in-progress

let
  version = "1.67.0.0";

  repository = "https://github.com/esp-rs/rust-build";

  downloadUrl = "${repository}/releases/download/v${version}";

  platform = {
    aarch64-darwin = "aarch64-apple-darwin";
    aarch64-linux = "aarch64-unknown-linux-gnu";
    x86_64-darwin = "x86_64-apple-darwin";
    x86_64-linux = "x86_64-unknown-linux-gnu";
  }.${stdenv.system};

in stdenv.mkDerivation rec {
  pname = "esp-rust-bin";

  inherit version;

  src = fetchurl {
    url = "${downloadUrl}/rust-${version}-${platform}.tar.xz";
    hash = {
      aarch64-apple-darwin =
        "sha256-2c4CXvPuMAQ7xe2pJKIIMELSYSCltZrFx/Nrm6VpM6c=";
      aarch64-unknown-linux-gnu =
        "sha256-95i8LYnk4pX+KStEHP2NZeHNzACykn53743+9X1Q+lc=";
      x86_64-apple-darwin =
        "sha256-s/VVefoc7Q1c79f1jzCu9G0bm+Wcb+R3h9qP14+qEAI=";
      x86_64-unknown-linux-gnu =
        "sha256-Tk1GQvzlXcMfIkN+yXtDA2BIkK00iKwLGt6eWNlKGsM=";
    }.${platform};
  };

  rust-src = fetchzip {
    name = "rust-src-${version}";
    url = "${downloadUrl}/rust-src-${version}.tar.xz";
    hash = "sha256-fFDPRA8iNh6vjnSHyBt+ymmlkOUbZEoFcBoDXyEfBog=";
  };

  nativeBuildInputs = lib.optional (!stdenv.isDarwin) autoPatchelfHook;
  buildInputs = lib.optionals (!stdenv.isDarwin) [ gcc.cc.lib zlib ]
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  installPhase = ''
    runHook preInstall
    bash install.sh --destdir=$out --prefix="" \
      --components=rustc,rust-std-${platform},cargo
    bash ${rust-src}/install.sh --destdir=$out --prefix="" \
      --components=rust-src
    runHook postInstall
  '';

  meta = with lib; {
    description =
      "Pre-built binaries of the Rust compiler fork with Xtensa support";
    homepage = repository;
    license = [ licenses.afl20 licenses.mit ];
    platforms =
      [ "aarch64-darwin" "aarch64-linux" "x86-64-darwin" "x86_64-linux" ];
  };
}
