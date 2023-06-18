{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin, writeShellScript
, nix-update }:

rustPlatform.buildRustPackage rec {
  pname = "gen-license";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "nexxeln";
    repo = "license-generator";
    rev = version;
    hash = "sha256-lecEWhxt035BUJ4Giqo5u1nDOaeo1C1VxEyB+I3+yB0=";
  };

  cargoHash = "sha256-2PT20eoXxBPhGsmHlEEGE2ZDyhyrD7tFdwnn3khjKNo=";

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
