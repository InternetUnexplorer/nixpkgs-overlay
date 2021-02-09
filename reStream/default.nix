{ stdenv, lib, fetchFromGitHub, fetchpatch, makeWrapper, coreutils, lz4
, ffmpeg-full, openssh }:

stdenv.mkDerivation rec {
  pname = "reStream";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "rien";
    repo = "reStream";
    rev = version;
    sha256 = "18z17chl7r5dg12xmr3f9gbgv97nslm8nijigd03iysaj6dhymp3";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/rien/reStream/pull/43.patch";
      sha256 = "029m2jfxrscsaa9flq0c4asvs96wr3xv2rw2cr9yz4jg7hswdwmb";
    })
  ];

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
