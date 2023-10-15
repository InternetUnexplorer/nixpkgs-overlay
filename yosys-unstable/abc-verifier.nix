{ abc-verifier, fetchFromGitHub }:

abc-verifier.overrideAttrs (final: prev: {
  version = "unstable-2023-10-13";

  src = fetchFromGitHub {
    owner = "yosysHQ";
    repo = "abc";
    rev = "896e5e7dedf9b9b1459fa019f1fa8aa8101fdf43";
    hash = "sha256-ou+E2lvDEOxXRXNygE/TyVi7quqk+CJHRI+HDI0xljE=";
  };

  passthru = (prev.passthru or { }) // { inherit (final.src) rev; };
})
