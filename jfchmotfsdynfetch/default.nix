{ stdenvNoCC, lib, fetchurl }:

stdenvNoCC.mkDerivation rec {
  name = "jfchmotfsdynfetch";
  progName = "jesusfuckingchristhowmanyofthesefetchscriptsdoyouneedfetch";

  src = fetchurl {
    url = "https://pastebin.com/raw/TfDWriSm";
    hash = "sha256-AOMfWxk+fvrXpaYUF6FYm38YuU3PwdW1aaox8JG/shA=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/${progName}
    runHook postInstall
  '';

  postFixup = ''
    # This can't be done in patchPhase since dontUnpack is set
    sed -i '1i #!${stdenvNoCC.shell}' $out/bin/${progName}
  '';

  passthru.exePath = "/bin/${progName}";

  meta = with lib; {
    description =
      "The MOST minimal fetch tool that fetches precisely NO information about your PC";
    homepage = "https://redd.it/yv76he";
    license = licenses.free;
    platforms = platforms.all;
  };
}
