{ stdenv, fetchurl, meson, ninja, fetchgit, python3, gobject-introspection
, pkgconfig, gtk3, pango, glib, desktop-file-utils, wrapGAppsHook, libdazzle
, libnotify, libappindicator }:

python3.pkgs.buildPythonApplication rec {
  pname = "gwe";
  version = "0.15.2";
  name = "${pname}-${version}";
  format = "other";

  src = fetchTarball {
    url =
      "https://gitlab.com/leinardi/gwe/-/archive/${version}/gwe-${version}.tar.gz";
    sha256 = "02sh6gzh9q4y8d8mfyg00g00xc3icg7c8822r1svj1ic1xlf5bj0";
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

  meta = with stdenv.lib; {
    description =
      "System utility designed to provide information, control the fans and overclock your NVIDIA card";
    homepage = "https://gitlab.com/leinardi/gwe";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
