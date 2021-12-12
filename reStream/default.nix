{ stdenv, lib, fetchFromGitHub, fetchpatch, makeWrapper, coreutils, lz4
, ffmpeg-full, openssh }:

let
  pname = "reStream";
  version = "1.1";
  src = fetchFromGitHub {
    owner = "rien";
    repo = pname;
    rev = version;
    sha256 = "18z17chl7r5dg12xmr3f9gbgv97nslm8nijigd03iysaj6dhymp3";
  };
in stdenv.mkDerivation {
  inherit pname version src;

  patches = [
    (fetchpatch {
      url = "https://github.com/rien/reStream/pull/43.patch";
      sha256 = "sha256-IvZRNEQOdhbm+vjjLpV+hhe0MqQmi2pRz5D5uba+pto=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a reStream.sh $out/bin/reStream
    wrapProgram $out/bin/reStream \
      --set PATH ${lib.makeBinPath [ coreutils lz4 ffmpeg-full openssh ]}
  '';

  passthru.exePath = "/bin/reStream";

  meta = with lib; {
    description = "Stream your reMarkable screen over SSH";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
