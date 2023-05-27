# Nixpkgs Overlay

This is my personal Nixpkgs overlay with some packages I use. Feel free to use
it, just keep in mind that packages might break or be removed over time!

The packages here are regularly built against nixos-unstable and pushed to [my
binary cache][1].

### License

The following files were copied from Nixpkgs and are subject to the [Nixpkgs license][2]:

- [ksysguard/ksysguard.nix](./ksysguard/ksysguard.nix)
- [squeak_4_10/squeak_4_10.nix](./squeak_4_10/squeak_4_10.nix)
- [yosys-unstable/plugin-search-dirs.patch](./yosys-unstable/plugin-search-dirs.patch)

All other files are licensed under [CC0][3].

[1]: https://internetunexplorer.cachix.org/
[2]: https://github.com/NixOS/nixpkgs/blob/master/COPYING
[3]: https://creativecommons.org/publicdomain/zero/1.0/
