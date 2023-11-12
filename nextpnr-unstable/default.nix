{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-11-09";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "506d5f9422f57642a78008b71fd0c0434154d648";
    hash = "sha256-IfZZtR4aXlCMC1T0oe+VRv9Yhedsra3ioapsH27GZ9k=";
  };

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
