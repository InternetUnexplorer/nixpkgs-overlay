{ lib, stdenv, fetchFromGitHub, cmake, zstd }:

stdenv.mkDerivation rec {
  pname = "t2sz";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "martinellimarco";
    repo = "t2sz";
    rev = "v${version}";
    hash = "sha256-RX652UNmPJog2n8onkPDD/uXfNASur/dD2F1lPHj1vE=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zstd ];

  meta = {
    description =
      "Compress a file into a seekable zstd with special handling for .tar archives";
    homepage = "https://github.com/martinellimarco/t2sz";
    license = lib.licenses.gpl3Only;
    mainProgram = "t2sz";
    platforms = lib.platforms.all;
  };
}
