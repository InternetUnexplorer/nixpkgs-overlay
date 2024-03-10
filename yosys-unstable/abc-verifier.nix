{ abc-verifier, fetchFromGitHub }:

abc-verifier.overrideAttrs (final: prev: {
  version = "unstable-2024-03-04";

  src = fetchFromGitHub {
    owner = "yosysHQ";
    repo = "abc";
    rev = "0cd90d0d2c5338277d832a1d890bed286486bcf5";
    hash = "sha256-1v/HOYF/ZdfR75eC3uYySKs2k6ZLCTUI0rtzPQs0hKQ=";
  };

  passthru = (prev.passthru or { }) // { inherit (final.src) rev; };
})
