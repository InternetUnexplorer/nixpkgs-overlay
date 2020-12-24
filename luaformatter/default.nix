{ stdenv, fetchFromGitHub, cmake, gcc }:

stdenv.mkDerivation rec {
  pname = "luaformatter";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "Koihik";
    repo = "LuaFormatter";
    rev = version;
    sha256 = "1igdcjbzm7z78f66856njxz7hpj3rjynb3sz899bv0p5sqv75j0c";
    fetchSubmodules = true;
  };

  buildInputs = [ cmake gcc ];

  meta = {
    description = "Code formatter for Lua";
    homepage = "https://github.com/Koihik/LuaFormatter";
    license = "Apache-2.0";
  };
}
