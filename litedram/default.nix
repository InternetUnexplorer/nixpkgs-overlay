{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "litedram";
  version = "2023.04";

  src = fetchFromGitHub {
    owner = "enjoy-digital";
    repo = "litedram";
    rev = version;
    hash = "sha256-zugIHOu1cakFFshYV1LyUeHQWKYpRQQ49eXlWGM2GKo=";
  };

  propagatedBuildInputs = with python3Packages; [
    (callPackage ./litex.nix { })
    migen
    pyyaml
  ];

  doCheck = false; # FIXME

  passthru = {
    autoUpdate = "git-tags";
    exePath = "/bin/litedram_gen";
  };

  meta = with lib; {
    description = "Small footprint and configurable DRAM core";
    inherit (src.meta) homepage;
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
