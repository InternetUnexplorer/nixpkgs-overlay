{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-09-16";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "8e84006ee71ce941b4f089bd824ce139f4cefad5";
    hash = "sha256-IND5SHjqwR6jql+npLT3F/znxgdBikl0c9KNIEQ8lwo=";
  };

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
