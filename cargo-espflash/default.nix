{ cargo-espflash, fetchFromGitHub, openssl, udev, writeShellScript, nix-update
}:

cargo-espflash.overrideAttrs (old: rec {
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    rev = "v${version}";
    hash = "sha256-PYW5OM3pbmROeGkbGiLhnVGrYq6xn3B1Z4sbIjtAPlk=";
  };

  buildInputs = [ openssl udev ];

  OPENSSL_NO_VENDOR = 1;

  cargoDeps = old.cargoDeps.overrideAttrs (_: {
    inherit src;
    outputHash = "sha256-gTehRP9Ct150n3Kdz+NudJcKGeOCT059McrXURhy2iQ=";
  });

  passthru.updateScript = writeShellScript "update-${old.pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${old.pname} --version unstable
  '';
})
