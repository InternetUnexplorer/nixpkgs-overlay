{ openrgb, fetchFromGitLab }:

openrgb.overrideAttrs (old: {
  src = fetchFromGitLab {
    owner = "TheRogueZeta";
    repo = "OpenRGB";
    rev = "70a7ea8e014e96729abd4858602b7fc982225b44";
    hash = "sha256-zQEgIy06avQPPAfZlZwLcuEnBgblvuLXFeNLL/0Ct2s=";
  };
})
