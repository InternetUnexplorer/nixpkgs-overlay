{ transmission-qt }:

transmission-qt.overrideAttrs
(old: { patches = (old.patches or [ ]) ++ [ ./0000-fix-progress-bars.patch ]; })
