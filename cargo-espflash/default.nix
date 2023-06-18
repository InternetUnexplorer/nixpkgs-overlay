{ cargo-espflash, fetchFromGitHub, openssl, udev, writeShellScript, nix-update
}:

cargo-espflash.overrideAttrs (old: rec {
  version = "2.0.0-rc.4";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    rev = "v${version}";
    hash = "sha256-jDOaJq/8KOytxz0tUi6AyU8oIGzPSZmiHdS49CjeiWo=";
  };

  buildInputs = [ openssl udev ];

  OPENSSL_NO_VENDOR = 1;

  cargoDeps = old.cargoDeps.overrideAttrs (_: {
    inherit src;
    outputHash = "sha256-VmY36TNtcBqeWOeRaH3oA1l205o43NJIXt5AamCs8T0=";
  });

  passthru.updateScript = writeShellScript "update-${old.pname}" ''
    set -e -u -x -o pipefail
    exec ${nix-update}/bin/nix-update --flake ${old.pname} --version unstable
  '';
})
