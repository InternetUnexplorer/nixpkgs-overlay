{ cargo-espflash, fetchFromGitHub, openssl, udev, writeShellScript, nix-update
}:

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

  cargoDeps = old.cargoDeps.overrideAttrs (_: {
    inherit src;
    outputHash = "sha256-mp9Qafk3eV5tF9cZ53F58t17cWoHZMRK6krvSGrOgV8=";
  });

  passthru.updateScript = writeShellScript "update-${old.pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${old.pname} --version unstable
  '';
})
