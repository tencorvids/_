{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  users.users = {
    ${username} = {
      isNormalUser = true;
      description = username;
      initialPassword = "123";
      # shell = pkgs.zsh;
      extraGroups = ["networkmanager" "wheel" "input" "docker" "kvm" "libvirtd"];
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
  ];

  system.stateVersion = "24.05";
}
