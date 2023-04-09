{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "license-generator";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "nexxeln";
    repo = "license-generator";
    rev = version;
    hash = "sha256-lecEWhxt035BUJ4Giqo5u1nDOaeo1C1VxEyB+I3+yB0=";
  };

  cargoHash = "sha256-nm9tX3jXN6SgRkWBygs61gAXRzw5IbcaA2oCkMd3w3k=";

  buildInputs =
    lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  passthru.autoUpdate = "github-releases";

  meta = with lib; {
    description = "Create licenses for your projects right from your terminal";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
