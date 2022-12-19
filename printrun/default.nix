{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "printrun";
  version = "unstable-2022-12-13";

  src = fetchFromGitHub {
    owner = "kliment";
    repo = "Printrun";
    rev = "8fd9b8b6dab86ee0c238016f9a0ed7b0c5abea73";
    hash = "sha256-lZcGKfcBx9LVXkJ3diqdC9VnP2zHjJjCDw/NKMizJ2A=";
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
