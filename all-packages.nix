{ lib, callPackage }:

let isPackage = name: type: type == "directory" && !lib.hasPrefix "." name;
in lib.mapAttrs (name: _: callPackage (./. + "/${name}") { })
(lib.filterAttrs isPackage (builtins.readDir ./.))
