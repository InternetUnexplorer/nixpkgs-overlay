{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "printrun";
  version = "unstable-2023-04-13";

  src = fetchFromGitHub {
    owner = "kliment";
    repo = "Printrun";
    rev = "f652640c0342d737a2315136ed8be0ef03cb9303";
    hash = "sha256-Yn9uUGtZ9QpAwdNnDPcNTur6ey4raXsc4/ZT+XkYNN0=";
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
