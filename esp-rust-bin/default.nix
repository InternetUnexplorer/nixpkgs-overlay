{ stdenv, lib, fetchurl, fetchzip, autoPatchelfHook, gcc, zlib, darwin }:

# NOTE: This is a work-in-progress

let
  version = "1.66.0.0";

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
        "sha256-nJMLowwf7Mz9o/+fDa+xA6c6L3wexu/MsLKPnI/OhBE=";
      aarch64-unknown-linux-gnu =
        "sha256-yEMoTcP4uXDINlzMVlqUvJmQP8tH/2IfvYkAUWhpAjc=";
      x86_64-apple-darwin =
        "sha256-MJOw+Si9AJwolfVVFHC6i42JIti4h2vskxuo2kYi9RM=";
      x86_64-unknown-linux-gnu =
        "sha256-jgSVwYYcQB8SAJR1j/Qhzmn8fcqumZT615qTSfHifVE=";
    }.${platform};
  };

  rust-src = fetchzip {
    url = "${downloadUrl}/rust-src-${version}.tar.xz";
    hash = "sha256-JZl6w/oey/b8Efp6kodv8CifSy7snwFIUvUIIp9eD0U=";
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
