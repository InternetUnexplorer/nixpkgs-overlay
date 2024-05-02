{ cargo-espflash, fetchFromGitHub, openssl, udev, writeShellScript, nix-update
}:

cargo-espflash.overrideAttrs (old: rec {
  version = "3.0.0-rc.1";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    rev = "v${version}";
    hash = "sha256-mKlkcqCtGVcaHaioZw+pfo6tBGTY4mK2KOSzJxBOL8Q=";
  };

  buildInputs = [ openssl udev ];

  OPENSSL_NO_VENDOR = 1;

  cargoDeps = old.cargoDeps.overrideAttrs (_: {
    inherit src;
    outputHash = "sha256-8CfNlHixj/IPVnqKBCIohUWtUIhVGnaMVQkfHbazXcI=";
  });

  passthru.updateScript = writeShellScript "update-${old.pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${old.pname} --version unstable
  '';
})
