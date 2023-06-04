{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "printrun";
  version = "unstable-2023-05-29";

  src = fetchFromGitHub {
    owner = "kliment";
    repo = "Printrun";
    rev = "ceeb651ca9fa4c20757ba37128b552dde4662952";
    hash = "sha256-QIc0myqMXjWh+3mWmNIL29nKKu+s6CGLdy4LUstKPJs=";
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
