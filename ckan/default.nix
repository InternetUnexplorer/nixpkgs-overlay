{ ckan, mono, fetchpatch }:

let
  mono-pull-21136 = fetchpatch {
    url =
      "https://patch-diff.githubusercontent.com/raw/mono/mono/pull/21136.patch";
    sha256 = "sha256-4mUkkRl2IoNjkZN8+1Ps3kvI9Tu2BnH4YqeRZ6A/UMU=";
  };
in ckan.override (_: {
  mono = mono.overrideAttrs
    (old: { patches = (old.patches or [ ]) ++ [ mono-pull-21136 ]; });
})
