{ pkgs }:

pkgs.callPackage ./blender_2_93.nix {
  inherit (pkgs.darwin.apple_sdk.frameworks)
    Cocoa CoreGraphics ForceFeedback OpenAL OpenGL;
}
