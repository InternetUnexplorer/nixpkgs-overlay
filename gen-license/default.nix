{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin, writeShellScript
, nix-update }:

rustPlatform.buildRustPackage rec {
  pname = "gen-license";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "nexxeln";
    repo = "license-generator";
    rev = version;
    hash = "sha256-VOmt8JXd2+ykhkhupv/I4RfXz9P0eEesW3JGAoXStUI=";
  };

  cargoHash = "sha256-TEsWACxEs4eJ8rO4RnKJWpwT1KcDoBEGftHSJt4YXVw=";

  buildInputs =
    lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Create licenses for your projects right from your terminal";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.all;
  };

  passthru.updateScript = writeShellScript "update-${pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${pname}
  '';
}
