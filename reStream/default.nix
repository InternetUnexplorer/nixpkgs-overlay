{ stdenv, lib, fetchFromGitHub, fetchpatch, makeWrapper, coreutils, lz4
, ffmpeg-full, openssh }:

let
  pname = "reStream";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "rien";
    repo = pname;
    rev = version;
    hash = "sha256-L6U+xHmG3Q34qmluh3rRJbA4SG448JXFtjEx9OwE0m8=";
  };
in stdenv.mkDerivation {
  inherit pname version src;

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
