{ plasma5, fetchpatch }:

let llPatchVersion = "5.18.5-2";

in plasma5.kwin.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    (fetchpatch {
      url =
        "https://tildearrow.zapto.org/storage/kwin-lowlatency/kwin-lowlatency-${llPatchVersion}.patch";
      sha256 = "009g7kay8lq593x3f1qi8j43nmmlkg9xkhvzqvyn90066k2f89qb";
    })
  ];
})
