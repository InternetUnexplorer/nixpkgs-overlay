{ lib, buildGoModule, fetchFromGitHub, pkg-config, gtk3
, libayatana-appindicator-gtk3 }:

buildGoModule rec {
  pname = "tailscale-systray";
  version = "unstable-2022-10-19";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "tailscale-systray";
    rev = "e7f8893684e7b8779f34045ca90e5abe6df6056d";
    hash = "sha256-3kozp6jq0xGllxoK2lGCNUahy/FvXyq11vNSxfDehKE=";
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
}
