# Nixpkgs Overlay

This is my personal Nixpkgs overlay with some packages I use. Feel free to use
it, just keep in mind that packages might break or be removed over time!

The packages here are regularly built against nixos-unstable and pushed to [my
binary cache][1].

### License

The following files were copied from Nixpkgs and are subject to the [Nixpkgs license][2]:

- [easyeffects_7_0_4/default.nix](easyeffects_7_0_4/default.nix)
- [ksysguard/ksysguard.nix](./ksysguard/ksysguard.nix)
- [squeak_4_10/squeak_4_10.nix](./squeak_4_10/squeak_4_10.nix)
- [yosys-unstable/plugin-search-dirs.patch](./yosys-unstable/plugin-search-dirs.patch)

The patches in [easyeffects_7_0_4](easyeffects_7_0_4) were copied from
easyeffects and are subject to the [easyeffects license][3].

All other files are licensed under [CC0][4].

[1]: https://internetunexplorer.cachix.org/
[2]: https://github.com/NixOS/nixpkgs/blob/master/COPYING
[3]: https://github.com/wwmm/easyeffects/blob/master/LICENSE
[4]: https://creativecommons.org/publicdomain/zero/1.0/
