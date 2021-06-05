{ lib }:

let isPackage = name: type: type == "directory" && !lib.hasPrefix "." name;

in lib.mapAttrsToList (name: _: name)
(lib.filterAttrs isPackage (builtins.readDir ./.))
