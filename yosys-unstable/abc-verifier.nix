{ abc-verifier, fetchFromGitHub }:

abc-verifier.overrideAttrs (final: prev: {
  version = "unstable-2023-09-13";

  src = fetchFromGitHub {
    owner = "yosysHQ";
    repo = "abc";
    rev = "daad9ede0137dc58487a0abc126253e671a85b14";
    hash = "sha256-5XeFYvdqT08xduFUDC5yK1jEOV1fYzyQD7N9ZmG3mpQ=";
  };

  passthru = (prev.passthru or { }) // { inherit (final.src) rev; };
})
