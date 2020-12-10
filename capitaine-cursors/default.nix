{ capitaine-cursors }:

capitaine-cursors.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [ ./capitaine-cursors-1.75x.patch ];
})
