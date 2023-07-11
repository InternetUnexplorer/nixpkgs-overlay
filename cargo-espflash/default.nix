{ cargo-espflash, fetchFromGitHub, openssl, udev, writeShellScript, nix-update
}:

cargo-espflash.overrideAttrs (old: rec {
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    rev = "v${version}";
    hash = "sha256-3E0OC8DVP2muLyoN4DQfrdnK+idQEm7IpaA/CUIyYnU=";
  };

  buildInputs = [ openssl udev ];

  OPENSSL_NO_VENDOR = 1;

  cargoDeps = old.cargoDeps.overrideAttrs (_: {
    inherit src;
    outputHash = "sha256-8VIAmmtaQoIvD7wN+W3yUM0CEDadOQrv1wnJ4/AWKFA=";
  });

  passthru.updateScript = writeShellScript "update-${old.pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${old.pname} --version unstable
  '';
})
