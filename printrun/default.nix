{ lib, fetchFromGitHub, python311Packages, writeShellScript, nix-update }:

python311Packages.buildPythonApplication rec {
  pname = "printrun";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "kliment";
    repo = "Printrun";
    rev = "printrun-${version}";
    hash = "sha256-MANgxE3z8xq8ScxdxhwfEVsLMF9lgcdSjJZ0qu5p3ps=";
  };

  propagatedBuildInputs = with python311Packages; [
    appdirs
    cairocffi
    cairosvg
    cython
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

  meta = with lib; {
    description = "Pure Python 3D printing host software";
    inherit (src.meta) homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.linux; # TODO
  };

  passthru.updateScript = writeShellScript "update-${pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${pname} --version-regex 'printrun-(.*)'
  '';
  passthru.exePath = "/bin/pronterface.py";
}
