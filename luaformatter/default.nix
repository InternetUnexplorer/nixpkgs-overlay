{ stdenv, fetchFromGitHub, cmake, gcc }:

stdenv.mkDerivation rec {
  pname = "luaformatter";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "Koihik";
    repo = "LuaFormatter";
    rev = version;
    sha256 = "163190g37r6npg5k5mhdwckdhv9nwy2gnfp5jjk8p0s6cyvydqjw";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake gcc ];

  meta = {
    description = "Code formatter for Lua";
    homepage = "https://github.com/Koihik/LuaFormatter";
    license = "Apache-2.0";
  };
}
