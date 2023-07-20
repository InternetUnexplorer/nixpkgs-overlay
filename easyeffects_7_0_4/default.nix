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
# https://github.com/NixOS/nixpkgs/blob/4bc72cae107788bf3f24f30db2e2f685c9298dc9/pkgs/applications/audio/easyeffects/default.nix
#

{ lib, stdenv, desktop-file-utils, fetchFromGitHub, calf, fftw, fftwFloat, fmt_9
, glib, gsl, gtk4, itstool, libadwaita, libbs2b, libebur128, libsamplerate
, libsigcxx30, libsndfile, lilv, lsp-plugins, lv2, mda_lv2, meson, ninja
, nlohmann_json, pipewire, pkg-config, rnnoise, rubberband, speexdsp, tbb
, wrapGAppsHook4, zam-plugins, zita-convolver }:

stdenv.mkDerivation rec {
  pname = "easyeffects";
  version = "7.0.4";

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "easyeffects";
    rev = "v${version}";
    hash = "sha256-JaqwzCWVnvFzzGHnmzYwe3occ9iw7s9xCH54eVKEuOs=";
  };

  nativeBuildInputs =
    [ desktop-file-utils itstool meson ninja pkg-config wrapGAppsHook4 ];

  buildInputs = [
    fftw
    fftwFloat
    fmt_9
    glib
    gsl
    gtk4
    libadwaita
    libbs2b
    libebur128
    libsamplerate
    libsigcxx30
    libsndfile
    lilv
    lv2
    nlohmann_json
    pipewire
    rnnoise
    rubberband
    speexdsp
    tbb
    zita-convolver
  ];

  preFixup = let
    lv2Plugins = [
      calf # compressor exciter, bass enhancer and others
      lsp-plugins # delay, limiter, multiband compressor
      mda_lv2 # loudness
      zam-plugins # maximizer
    ];
    ladspaPlugins = [
      rubberband # pitch shifting
    ];
  in ''
    gappsWrapperArgs+=(
      --set LV2_PATH "${lib.makeSearchPath "lib/lv2" lv2Plugins}"
      --set LADSPA_PATH "${lib.makeSearchPath "lib/ladspa" ladspaPlugins}"
    )
  '';

  separateDebugInfo = true;

  meta = with lib; {
    description = "Audio effects for PipeWire applications.";
    homepage = "https://github.com/wwmm/easyeffects";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };

  passthru.exePath = "/bin/easyeffects";
}
