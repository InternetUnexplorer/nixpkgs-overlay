{ abc-verifier, fetchFromGitHub }:

abc-verifier.overrideAttrs (final: prev: {
  version = "unstable-2023-02-23";

  src = fetchFromGitHub {
    owner = "yosysHQ";
    repo = "abc";
    rev = "2c1c83f75b8078ced51f92c697da3e712feb3ac3";
    hash = "sha256-THcyEifIp9v1bOofFVm9NFPqgI6NfKKys+Ea2KyNpv8=";
  };

  passthru = (prev.passthru or { }) // { inherit (final.src) rev; };
})
