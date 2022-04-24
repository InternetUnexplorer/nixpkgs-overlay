# This file was copied from Nixpkgs and is subject to the Nixpkgs license:
#
# Copyright (c) 2003-2022 Eelco Dolstra and the Nixpkgs/NixOS contributors
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# The original version of this file can be found at:
# https://github.com/NixOS/nixpkgs/blob/611e9302f9b33ca72cfce239445444aad3653b47/pkgs/development/compilers/squeak/default.nix
#

{ lib, stdenv, fetchurl, cmake, coreutils, dbus, freetype, glib, gnused
, libpthreadstubs, pango, pkg-config, libpulseaudio, which }:

stdenv.mkDerivation rec {
  pname = "squeak";
  version = "4.10.2.2614";

  src = fetchurl {
    sha256 = "0bpwbnpy2sb4gylchfx50sha70z36bwgdxraym4vrr93l8pd3dix";
    url = "http://squeakvm.org/unix/release/Squeak-${version}-src.tar.gz";
  };

  buildInputs = [
    coreutils
    dbus
    freetype
    glib
    gnused
    libpthreadstubs
    pango
    libpulseaudio
    which
  ];
  nativeBuildInputs = [ cmake pkg-config ];

  postPatch = ''
    for i in squeak.in squeak.sh.in; do
      substituteInPlace unix/cmake/$i --replace "PATH=" \
        "PATH=${lib.makeBinPath [ coreutils gnused which ]} #"
    done
  '';

  configurePhase = ''
    unix/cmake/configure --prefix=$out --enable-mpg-{mmx,pthreads}
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Smalltalk programming language and environment";
    longDescription = ''
      Squeak is a full-featured implementation of the Smalltalk programming
      language and environment based on (and largely compatible with) the
      original Smalltalk-80 system. Squeak has very powerful 2- and 3-D
      graphics, sound, video, MIDI, animation and other multimedia
      capabilities. It also includes a customisable framework for creating
      dynamic HTTP servers and interactively extensible Web sites.
    '';
    homepage = "http://squeakvm.org/";
    downloadPage = "http://squeakvm.org/unix/index.html";
    license = with licenses; [ asl20 mit ];
    platforms = platforms.linux;
  };

  passthru.exePath = "/bin/squeak";
}
