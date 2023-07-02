{ abc-verifier, fetchFromGitHub }:

abc-verifier.overrideAttrs (final: prev: {
  version = "unstable-2023-06-28";

  src = fetchFromGitHub {
    owner = "yosysHQ";
    repo = "abc";
    rev = "bb64142b07794ee685494564471e67365a093710";
    hash = "sha256-Qkk61Lh84ervtehWskSB9GKh+JPB7mI1IuG32OSZMdg=";
  };

  passthru = (prev.passthru or { }) // { inherit (final.src) rev; };
})
