{ cargo-espflash, fetchFromGitHub, openssl, udev }:

cargo-espflash.overrideAttrs (old: rec {
  version = "2.0.0-rc.3";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    rev = "v${version}";
    hash = "sha256-6rWv/a+tg0dn5BEZ2JCEqAIFBufuDxImfdIuqrfS0VA=";
  };

  buildInputs = [ openssl udev ];

  OPENSSL_NO_VENDOR = 1;

  # This will fail, because update.py doesn't know how to update this.
  # The failure will trigger a notification, so this is basically a reminder to
  # update it manually.
  passthru.autoUpdate = "git-tags";

  cargoDeps = old.cargoDeps.overrideAttrs (_: {
    inherit src;
    outputHash = "sha256-mp9Qafk3eV5tF9cZ53F58t17cWoHZMRK6krvSGrOgV8=";
  });
})
