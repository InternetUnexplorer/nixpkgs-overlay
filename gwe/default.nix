{ stdenv, lib, fetchurl, fetchFromGitLab, meson, ninja, fetchgit, python3
, gobject-introspection, pkgconfig, gtk3, pango, glib, desktop-file-utils
, wrapGAppsHook, libdazzle, libnotify, libappindicator }:

# Requires `hardware.opengl.setLdLibraryPath = true;` in `configuration.nix`.

python3.pkgs.buildPythonApplication rec {
  pname = "gwe";
  version = "0.15.3";
  format = "other";

  src = fetchFromGitLab {
    owner = "leinardi";
    repo = "gwe";
    rev = version;
    hash = "sha256-P91ezv+1ywQ3oHY21aI2VlmFWFebP2Y4enQCKcATzf4=";
  };

  nativeBuildInputs =
    [ desktop-file-utils meson gtk3 ninja pkgconfig wrapGAppsHook ];

  buildInputs = [
    libdazzle
    libnotify
    libappindicator
    gobject-introspection
    gtk3
    glib
    python3
  ];

  propagatedBuildInputs = with python3.pkgs; [
    (python3.pkgs.buildPythonPackage rec {
      pname = "injector";
      version = "0.18.4";
      src = fetchurl {
        url =
          "https://files.pythonhosted.org/packages/29/36/eaf271dd4c5325710f306245e257d969a8c4d1e79ea0d08cfeaad8cdd8f4/injector-0.18.4-py2.py3-none-any.whl";
        sha256 = "148g2wv9hg9garpm1a1c4jh8ryg5gbf2niz17zyb4c060mipwvly";
      };
      format = "wheel";
      doCheck = false;
      propagatedBuildInputs = [ typing-extensions ];
    })
    matplotlib
    peewee
    pygobject3
    pynvml
    pyxdg
    requests
    rx
    xlib
  ];

  postPatch = ''
    chmod +x scripts/meson_post_install.py
    patchShebangs scripts/meson_post_install.py
    substituteInPlace gwe/repository/nvidia_repository.py \
      --replace 'from py3nvml import py3nvml' 'import pynvml as py3nvml' \
      --replace 'from py3nvml.py3nvml import' 'from pynvml import'
  '';

  meta = with lib; {
    description =
      "System utility designed to provide information, control the fans and overclock your NVIDIA card";
    homepage = "https://gitlab.com/leinardi/gwe";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
