{ stdenv, lib, fetchFromGitHub, makeWrapper, coreutils, lz4, ffmpeg-full
, openssh }:

stdenv.mkDerivation rec {
  pname = "reStream";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "rien";
    repo = "reStream";
    rev = version;
    sha256 = "0k6pm7v0hym2423r40yp1nd7zm06qmnzwf490ab04y0nr9mz2fw7";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a reStream.sh $out/bin/reStream
    wrapProgram $out/bin/reStream \
      --set PATH ${lib.makeBinPath [ coreutils lz4 ffmpeg-full openssh ]}
  '';

  meta = {
    description = "Stream your reMarkable screen over SSH";
    inherit (src.meta) homepage;
    license = "MIT";
  };
}
