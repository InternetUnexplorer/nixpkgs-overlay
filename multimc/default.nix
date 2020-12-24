{ multimc, glfw3 }:

multimc.overrideAttrs (old: {
  MULTIMC_LINUX_DATADIR = true;
})
