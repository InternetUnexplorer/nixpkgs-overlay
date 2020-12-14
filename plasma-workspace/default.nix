{ plasma5, fetchurl }:

let
  background-image = fetchurl {
    url = "https://i.imgur.com/yQ6Lbfb.jpg";
    sha256 = "1flsh6zcpxbh7ypjc14dngc75xsfn2bpz87c6pn612ljm5pvb2wk";
  };

in plasma5.plasma-workspace.overrideAttrs (old: {
  postPatch = (old.postPatch or "") + ''
    echo "[General]"                      >> sddm-theme/theme.conf.user
    echo "background=${background-image}" >> sddm-theme/theme.conf.user
  '';
})
