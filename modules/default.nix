{
  config,
  lib,
  gpu,
  ...
}: {
  imports =
    [
      ./boot.nix
      ./environment.nix
      ./hardware.nix
      ./os.nix
      ./services.nix
    ]
    ++ lib.optional (gpu == "nvidia") ./nvidia.nix;
}
