{ runCommand, plasma-workspace, fetchurl }:

let
  background-image = fetchurl {
    url = "https://i.imgur.com/yQ6Lbfb.jpg";
    sha256 = "1flsh6zcpxbh7ypjc14dngc75xsfn2bpz87c6pn612ljm5pvb2wk";
  };

in runCommand "breeze-mod-sddm-theme" { } ''
  mkdir -p $out/share/sddm/themes/breeze-mod
  ln -s ${plasma-workspace}/share/sddm/themes/breeze/* $out/share/sddm/themes/breeze-mod
  cat << EOF > $out/share/sddm/themes/breeze-mod/theme.conf.user
  [General]
  background=${background-image}
  EOF
''
