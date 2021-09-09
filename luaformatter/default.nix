{ luaformatter, fetchpatch, lib }:

luaformatter.overrideAttrs (old: {
  # Fix column_table_limit behavior
  patches = (old.patches or [ ]) ++ [
    (fetchpatch {
      url =
        "https://patch-diff.githubusercontent.com/raw/Koihik/LuaFormatter/pull/217.patch";
      sha256 = "sha256-OEjFqjFAUrT4nFnq/JbVCU8wG5NxvS7lrxpnfQiQ10g=";
    })
  ];

  meta.platforms = lib.platforms.linux ++ lib.platforms.darwin;
  passthru.exePath = "/bin/lua-format";
})
