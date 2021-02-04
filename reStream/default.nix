{ stdenv, lib, fetchFromGitHub, makeWrapper, coreutils, lz4, ffmpeg-full
, openssh }:

stdenv.mkDerivation rec {
  pname = "reStream";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "rien";
    repo = "reStream";
    rev = version;
    sha256 = "18z17chl7r5dg12xmr3f9gbgv97nslm8nijigd03iysaj6dhymp3";
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
