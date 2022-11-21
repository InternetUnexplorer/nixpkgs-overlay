{ cargo-espflash, fetchFromGitHub }:

cargo-espflash.overrideAttrs (old: rec {
  version = "2.0.0-rc.1";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    rev = "v${version}";
    hash = "sha256-7SZtgJoiFikOgR/PYof14cnaYQmQ0LKIUC2tuEUpUOk=";
  };

  # This will fail, because update.py doesn't know how to update this.
  # The failure will trigger a notification, so this is basically a reminder to
  # update it manually.
  passthru.autoUpdate = "github-releases";

  cargoDeps = old.cargoDeps.overrideAttrs (_: {
    inherit src;
    outputHash = "sha256-J8BZEmYxFCupc2fOXuk1svY213iB4/lmzpDLAcdcpZI=";
  });
})
