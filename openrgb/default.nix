{ openrgb, fetchFromGitLab }:

openrgb.overrideAttrs (old: {
  src = fetchFromGitLab {
    owner = "TheRogueZeta";
    repo = "OpenRGB";
    rev = "70a7ea8e014e96729abd4858602b7fc982225b44";
    sha256 = "0sxp0byjyjz32pby5gp50q32gqbj1ff9bn877h7z8sis5lij00fd";
  };
})
