{
  config,
  lib,
  pkgs,
  cpu,
  gpu,
  ...
}: {
  boot = {
    kernelModules = ["v4l2loopback"] ++ lib.optionals (cpu == "intel") ["kvm-intel"];
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    kernelParams =
      [
        "quiet"
        "systemd.show_status=auto"
        "rd.udev.log_level=3"
      ]
      ++ lib.optionals (gpu == "nvidia") [
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      ];
    supportedFilesystems = ["ntfs"];
    consoleLogLevel = 3;
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 8;
        theme = pkgs.fetchFromGitHub {
          owner = "Lxtharia";
          repo = "minegrub-theme";
          rev = "193b3a7c3d432f8c6af10adfb465b781091f56b3";
          sha256 = "1bvkfmjzbk7pfisvmyw5gjmcqj9dab7gwd5nmvi8gs4vk72bl2ap";
        };
      };
      # Explicitly disable systemd-boot
      systemd-boot.enable = lib.mkForce false;
    };
  };
}
# {
#   config,
#   lib,
#   pkgs,
#   cpu,
#   gpu,
#   ...
# }: let
#   efiAvailable = builtins.pathExists "/sys/firmware/efi/efivars";
# in {
#   boot = {
#     kernelModules = ["v4l2loopback"] ++ lib.optionals (cpu == "intel") ["kvm-intel"];
#     extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
#     kernelParams =
#       [
#         "quiet"
#         "systemd.show_status=auto"
#         "rd.udev.log_level=3"
#       ]
#       ++ lib.optionals (gpu == "nvidia") [
#         "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
#       ];
#     supportedFilesystems = ["ntfs"];
#     consoleLogLevel = 3;
#     kernelPackages = pkgs.linuxPackages_latest;
#
#     loader =
#       if efiAvailable
#       then {
#         systemd-boot.enable = false;
#         timeout = 10;
#         efi = {
#           canTouchEfiVariables = true;
#           efiSysMountPoint = "/boot";
#         };
#         grub = {
#           enable = true;
#           device = "nodev";
#           efiSupport = true;
#           useOSProber = true;
#           configurationLimit = 8;
#           theme = pkgs.fetchFromGitHub {
#             owner = "Lxtharia";
#             repo = "minegrub-theme";
#             rev = "193b3a7c3d432f8c6af10adfb465b781091f56b3";
#             sha256 = "1bvkfmjzbk7pfisvmyw5gjmcqj9dab7gwd5nmvi8gs4vk72bl2ap";
#           };
#         };
#       }
#       else {
#         systemd-boot.enable = false;
#         grub = {
#           enable = true;
#           # device = "/dev/vda";
#           device = "nodev";
#           useOSProber = true;
#           configurationLimit = 8;
#           theme = pkgs.fetchFromGitHub {
#             owner = "Lxtharia";
#             repo = "minegrub-theme";
#             rev = "193b3a7c3d432f8c6af10adfb465b781091f56b3";
#             sha256 = "1bvkfmjzbk7pfisvmyw5gjmcqj9dab7gwd5nmvi8gs4vk72bl2ap";
#           };
#         };
#       };
#   };
# }

