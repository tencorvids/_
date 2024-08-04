{...}: {
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };
}
# {
#   pkgs,
#   config,
#   ...
# }: {
#   hardware = {
#     nvidia = {
#       open = true;
#       nvidiaSettings = true;
#       powerManagement.enable = false;
#       modesetting.enable = true;
#       package = config.boot.kernelPackages.nvidiaPackages.stable;
#     };
#     graphics = {
#       enable = true;
#       enable32Bit = true;
#       extraPackages = with pkgs; [nvidia-vaapi-driver];
#     };
#   };
#   environment = {
#     variables = {
#       LIBVA_DRIVER_NAME = "nvidia";
#       XDG_SESSION_TYPE = "wayland";
#       GBM_BACKEND = "nvidia-drm";
#       __GLX_VENDOR_LIBRARY_NAME = "nvidia";
#       __GL_GSYNC_ALLOWED = "0";
#       __GL_VRR_ALLOWED = "0";
#       QT_AUTO_SCREEN_SCALE_FACTOR = "1";
#       QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
#       CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
#     };
#     sessionVariables = {
#       NIXOS_OZONE_WL = "1";
#       WLR_NO_HARDWARE_CURSORS = "1";
#       ELECTRON_OZONE_PLATFORM_HINT = "auto";
#     };
#     shellAliases = {nvidia-settings = "nvidia-settings --config='$XDG_CONFIG_HOME'/nvidia/settings";};
#   };
# }

