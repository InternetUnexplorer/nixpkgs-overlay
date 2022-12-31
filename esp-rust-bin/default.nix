{ stdenv, lib, fetchurl, symlinkJoin, callPackage }:

# NOTE: This is a work-in-progress

let
  version = "1.66.0.0";
  repository = "https://github.com/esp-rs/rust-build";
  platform = {
    aarch64-darwin = "aarch64-apple-darwin";
    aarch64-linux = "aarch64-unknown-linux-gnu";
    x86_64-darwin = "x86_64-apple-darwin";
    x86_64-linux = "x86_64-unknown-linux-gnu";
  }.${stdenv.system};
in symlinkJoin rec {
  name = "esp-rust-bin-${version}";

  src = fetchurl {
    url = let filename = "rust-${version}-${platform}.tar.xz";
    in "${repository}/releases/download/v${version}/${filename}";
    hash = (builtins.fromJSON (builtins.readFile ./checksums.json)).${platform};
  };

  meta = with lib; {
    description =
      "Pre-built binaries of the Rust compiler fork with Xtensa support";
    homepage = repository;
    license = [ licenses.afl20 licenses.mit ];
    platforms =
      [ "aarch64-darwin" "aarch64-linux" "x86-64-darwin" "x86_64-linux" ];
  };

  rustc = callPackage ./rustc.nix { inherit src version meta platform; };
  cargo = callPackage ./cargo.nix { inherit src version meta rustc; };

  paths = [ rustc cargo ];
}
