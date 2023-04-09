{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "printrun";
  version = "unstable-2023-04-03";

  src = fetchFromGitHub {
    owner = "kliment";
    repo = "Printrun";
    rev = "ea5c8caa5d8d4f8908f5ba490221c04d9176dcd9";
    hash = "sha256-OYuKi7yxlBDtycwkRteJJwS2W029GKP7K2KskvZXKXg=";
  };

  propagatedBuildInputs = with python3Packages; [
    appdirs
    cairocffi
    cairosvg
    cython_3
    lxml
    numpy
    psutil
    pyglet
    pyserial
    dbus-python
    six
    wxPython_4_2
  ];

  patchPhase = ''
    echo "" > requirements.txt # FIXME
    substituteInPlace printrun/utils.py \
      --replace 'sys.prefix' '"${placeholder "out"}"'
  '';

  postInstall = ''
    for file in $out/share/applications/*; do
      substituteInPlace $file       \
        --replace /usr/bin $out/bin \
        --replace /usr/share $out/share
    done
  '';

  doCheck = false;

  passthru = {
    autoUpdate = "git-commits";
    exePath = "/bin/pronterface.py";
  };

  meta = with lib; {
    description = "Pure Python 3D printing host software";
    inherit (src.meta) homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.linux; # TODO
  };
}
