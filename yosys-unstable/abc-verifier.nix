{ abc-verifier, fetchFromGitHub }:

abc-verifier.overrideAttrs (final: prev: {
  version = "unstable-2023-02-04";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "abc";
    rev = "a8f0ef2368aa56b3ad20a52298a02e63b2a93e2d";
    hash = "sha256-48i6AKQhMG5hcnkS0vejOy1PqFbeb6FpU7Yx0rEvHDI=";
  };

  passthru = prev.passthru // { inherit (final.src) rev; };
})
