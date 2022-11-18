{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, mesa, libpng
, vulkan-headers, vulkan-loader, glslang, x11Support ? stdenv.isLinux, xorg
, waylandSupport ? false, wayland, wayland-protocols }:

# TODO: Wayland support seems broken?

stdenv.mkDerivation rec {
  pname = "vkcube";
  version = "unstable-2022-11-08";

  src = fetchFromGitHub {
    owner = "krh";
    repo = "vkcube";
    rev = "f77395324a3297b2b6ffd7bce0383073e4670190";
    hash = "sha256-wGcQpfJqfK+hYVn4PsI8NjlP5HC40QKZPBE2oeEdgaI=";
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

  passthru.autoUpdate = "git-commits";

  meta = with lib; {
    description = "Spinning Vulkan cube";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin; # TODO: is this right?
  };
}
