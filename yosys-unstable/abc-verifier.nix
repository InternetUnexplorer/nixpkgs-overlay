{ abc-verifier, fetchFromGitHub }:

abc-verifier.overrideAttrs (final: prev: {
  version = "unstable-2023-06-06";

  src = fetchFromGitHub {
    owner = "yosysHQ";
    repo = "abc";
    rev = "1de4eafb0da0639199bd97f2fa98471e76327a6b";
    hash = "sha256-OU/Qbn7vYR5101fhtuHCW4Lst3V4JFVC9O4tgDRYrZM=";
  };

  passthru = (prev.passthru or { }) // { inherit (final.src) rev; };
})
