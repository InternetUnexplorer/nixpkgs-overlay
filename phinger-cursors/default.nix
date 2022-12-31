{ phinger-cursors }:

# https://github.com/phisch/phinger-cursors/issues/10
# https://github.com/phisch/phinger-cursors/issues/11
phinger-cursors.overrideAttrs (old: {
  postInstall = (old.postInstall or "") + ''
    for theme in $out/share/icons/*; do
      ln -s $theme/cursors/{kill,pirate}
      ln -s $theme/cursors/{help,dnd-ask}
      ln -s $theme/cursors/{copy,dnd-copy}
    done
  '';
})
