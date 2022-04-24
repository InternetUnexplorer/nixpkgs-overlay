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
# https://github.com/NixOS/nixpkgs/blob/a5cf968a5f7f0c93dcb375aefd4e8f90fec4b215/pkgs/desktops/plasma-5/ksysguard.nix
#

{ stdenv, fetchurl, lib, extra-cmake-modules, plasma5Packages, libcap, libnl
, libpcap, lm_sensors }:

let
  pname = "ksysguard";
  version = "5.22.0";
  mirror = "https://download.kde.org/stable";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "${mirror}/${pname}/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-D5xiTl+7Ku6QbY2VY8Wn6wnq84vI5DgsBy+ebYhUYi0=";
  };

  nativeBuildInputs = with plasma5Packages; [
    extra-cmake-modules
    kdoctools
    wrapQtAppsHook
  ];

  buildInputs = with plasma5Packages; [
    kconfig
    kcoreaddons
    ki18n
    kiconthemes
    kinit
    kitemviews
    knewstuff
    libcap
    libksysguard
    libnl
    libpcap
    lm_sensors
    networkmanager-qt
    qtbase
  ];

  meta = with lib; {
    description = "Resource usage monitor for your computer";
    homepage = "https://apps.kde.org/ksysguard";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

  passthru.exePath = "/bin/ksysguard";
}
