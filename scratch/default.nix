{ lib, symlinkJoin, buildFHSUserEnv, writeShellScriptBin, xdg_utils, callPackage
, unwrapped ? callPackage ../scratch-unwrapped { } }:

# Scratch.image contains a bunch of references to /usr/share/scratch (example
# projects, media library, and help files), and there doesn't seem to be any
# sane way to patch Squeak images, so this hack seems like the best choice.

let
  # Intercept calls to xdg-open and replace paths starting with
  # /usr/share/scratch so that the help files can be opened correctly.
  xdg-open = writeShellScriptBin "xdg-open" ''
    FILE=$(echo $1 | sed 's|^/usr/share/scratch|${unwrapped}/share/scratch|g')
    exec ${xdg_utils}/bin/xdg-open "$FILE"
  '';

  scratch-fhs = buildFHSUserEnv {
    name = "scratch";
    targetPkgs = _: [ xdg-open unwrapped ];
    runScript = "${unwrapped}/bin/scratch";
  };

in symlinkJoin {
  name = "scratch";
  paths = [ scratch-fhs unwrapped ];
  inherit (unwrapped) passthru meta;
}
