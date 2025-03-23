{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, mesa, libpng
, vulkan-headers, vulkan-loader, glslang, x11Support ? stdenv.isLinux, xorg
, waylandSupport ? false, wayland, wayland-protocols, writeShellScript
, nix-update }:

# TODO: Wayland support seems broken?

stdenv.mkDerivation rec {
  pname = "vkcube";
  version = "0-unstable-2024-06-17";

  src = fetchFromGitHub {
    owner = "krh";
    repo = "vkcube";
    rev = "ffd566971fac916fc90d33a442369d5717ceb2a9";
    hash = "sha256-pl4iZxcBYkNwB5GGncQUcr8VEd2+sQf5v66YBR2EEj0=";
  };

  nativeBuildInputs = [ meson ninja pkg-config glslang ];

  buildInputs = [ mesa libpng vulkan-headers vulkan-loader ]
    ++ lib.optional x11Support xorg.libxcb
    ++ lib.optionals waylandSupport [ wayland wayland-protocols ];

  installPhase = ''
    runHook preInstall
    install -Dm755 vkcube $out/bin/vkcube #
    runHook postInstall
  '';

  meta = with lib; {
    description = "Spinning Vulkan cube";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin; # TODO: is this right?
    broken = true; # Too sleepy to fix right now :'(
  };

  passthru.updateScript = writeShellScript "update-${pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${pname} --version branch
  '';
  passthru.exePath = "/bin/vkcube";
}
