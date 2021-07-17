{ capitaine-cursors }:

capitaine-cursors.overrideAttrs
(old: { patches = (old.patches or [ ]) ++ [ ./0001-add-1-75x-size.patch ]; })
