{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "printrun";
  version = "unstable-2023-01-26";

  src = fetchFromGitHub {
    owner = "kliment";
    repo = "Printrun";
    rev = "2cf3b2757c19cf135779858b920a9223db18bae3";
    hash = "sha256-wp95Kg4wavUE++iPKbTnIG5aLxA6bkXwqTVzKsEjeUI=";
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
    wxPython_4_1
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
    broken = true;
  };
}
