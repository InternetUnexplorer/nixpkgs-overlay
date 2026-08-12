{ lib, haskell, haskellPackages }:

let inherit (haskell.lib.compose) doJailbreak enableSeparateBinOutput;

in (enableSeparateBinOutput (doJailbreak (haskellPackages.callPackage
  ({ mkDerivation, base, cmdargs, directory, filepath, megaparsec
    , parser-combinators, safe-exceptions, scientific, text, unix, }:
    mkDerivation {
      pname = "nixfmt";
      version = "0.6.0";
      sha256 = "0jgg8cp2q6ip15cjw10zk2ff4avqc5nwd8amkrrqm0zka41pc0jz";
      isLibrary = true;
      isExecutable = true;
      libraryHaskellDepends =
        [ base megaparsec parser-combinators scientific text ];
      executableHaskellDepends =
        [ base cmdargs directory filepath safe-exceptions text unix ];
      description = "An opinionated formatter for Nix";
      license = lib.licenses.mpl20;
      mainProgram = "nixfmt";
    }) { }))).bin
