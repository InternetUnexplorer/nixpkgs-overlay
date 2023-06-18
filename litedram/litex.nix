{ lib, fetchFromGitHub, buildPythonApplication, migen, pyserial, requests }:

buildPythonApplication rec {
  pname = "litex";
  version = "2022.08";

  src = fetchFromGitHub {
    owner = "enjoy-digital";
    repo = "litex";
    rev = version;
    hash = "sha256-ibiUzNckxPK//mPrjPIpzOzo0D+FIhUomXeIiXdenhc=";
  };

  propagatedBuildInputs = [ migen pyserial requests ];

  doCheck = false; # FIXME

  meta = with lib; {
    description = "A Migen/MiSoC based Core/SoC builder";
    inherit (src.meta) homepage;
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
