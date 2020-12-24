{ plasma5, fetchpatch }:

let llPatchVersion = "5.20.4";

in plasma5.kwin.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    (fetchpatch {
      url =
        "https://github.com/tildearrow/kwin-lowlatency/releases/download/v${llPatchVersion}/kwin-lowlatency-${llPatchVersion}.patch";
      sha256 = "0w5bqhgpzmcnpby9rlki1m3705y47cvlq0yl976605bv7s5bj39l";
    })
  ];
})
