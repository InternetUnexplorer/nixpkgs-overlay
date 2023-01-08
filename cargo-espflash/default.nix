{ cargo-espflash, fetchFromGitHub, openssl, udev }:

cargo-espflash.overrideAttrs (old: rec {
  version = "2.0.0-rc.2";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    rev = "v${version}";
    hash = "sha256-g20dhsWWf5T2Hcr9HEkezwwx1Q/ZQkN0ch/zEH6MeII=";
  };

  buildInputs = [ openssl udev ];

  OPENSSL_NO_VENDOR = 1;

  # This will fail, because update.py doesn't know how to update this.
  # The failure will trigger a notification, so this is basically a reminder to
  # update it manually.
  passthru.autoUpdate = "git-tags";

  cargoDeps = old.cargoDeps.overrideAttrs (_: {
    inherit src;
    outputHash = "sha256-Mh3ryJV8ae53PKRHTC3EVd15ZjGDVvbQKSzgXEVDGOc=";
  });
})
