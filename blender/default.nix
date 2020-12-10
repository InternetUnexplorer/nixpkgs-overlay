{ blender, fetchzip }:

let
  optix-include = fetchzip {
    url =
      "https://developer.download.nvidia.com/redist/optix/v7.0/OptiX-7.0.0-include.zip";
    sha256 = "1b3ccd3197anya2bj3psxdrvrpfgiwva5zfv2xmyrl73nb2dvfr7";
  };

in blender.overrideAttrs (old: {
  cmakeFlags = (old.cmakeFlags or [ ])
    ++ [ "-DWITH_CYCLES_DEVICE_OPTIX=ON" "-DOPTIX_ROOT_DIR=${optix-include}" ];
})
