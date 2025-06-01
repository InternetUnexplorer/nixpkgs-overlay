{ lib, buildGoModule, fetchFromGitHub, pkg-config, gtk3
, libayatana-appindicator-gtk3, writeShellScript, nix-update }:

buildGoModule rec {
  pname = "tailscale-systray";
  version = "0-unstable-2025-05-28";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "tailscale-systray";
    rev = "d3d0b625ed3b628e9898c8a43151ce152e82d9a7";
    hash = "sha256-dmM/q4eov//G7bDmYTqLxsd4cELEjWw53Olbe7r6+Bw=";
  };

  vendorHash = "sha256-cztIq7Kkj5alAYDtbPU/6h5S+nG+KAyxJzHBb3pJujs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 libayatana-appindicator-gtk3 ];

  meta = with lib; {
    description = "Linux port of tailscale system tray menu";
    homepage = "https://github.com/mattn/tailscale-systray";
    license = licenses.mit;
    platforms = platforms.linux;
  };

  passthru.updateScript = writeShellScript "update-${pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${pname} --version branch
  '';
  passthru.exePath = "/bin/tailscale-systray";
}
