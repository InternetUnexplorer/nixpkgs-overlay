{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2024-03-13";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "ff96fc5af1d220b5e84a4ddfb3d8634a4d8d56ef";
    hash = "sha256-t9BSQFJporDnP8ix5GR0GjXr0Wlm2ELz6e3nNa4AtHo=";
  };

  doCheck = false; # Takes too long :(

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
