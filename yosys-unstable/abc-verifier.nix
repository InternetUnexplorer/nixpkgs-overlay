{ abc-verifier, fetchFromGitHub }:

abc-verifier.overrideAttrs (final: prev: {
  version = "yosys-0.40-unstable-2024-04-23";

  src = fetchFromGitHub {
    owner = "yosysHQ";
    repo = "abc";
    rev = "03da96f12fb4deb153cc0dc73936df346ecd4bcf";
    hash = "sha256-1VHI03S3POkD+LJzBdnhLy1GPzAcbEzctbUhnUPd21k=";
  };

  passthru = (prev.passthru or { }) // { inherit (final.src) rev; };
})
