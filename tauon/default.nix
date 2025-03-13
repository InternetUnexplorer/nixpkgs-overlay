{ tauon, fetchpatch }:

let
  tauon-pull-1440 = fetchpatch {
    url =
      "https://patch-diff.githubusercontent.com/raw/Taiko2k/Tauon/pull/1440.patch";
    hash = "sha256-mBTA9LxcPFs8pzoGmwRCsxusH6gpHzjNVbs10EvXoOQ=";
  };
in tauon.overrideAttrs
(old: { patches = (old.patches or [ ]) ++ [ tauon-pull-1440 ]; })
