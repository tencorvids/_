{
  username,
  homeDirectory,
  ...
}: {
  imports = [
    ./apps
    ./shell
    ./wm
    ./fonts.nix
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "24.05";
  };

  programs = {
    home-manager.enable = true;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
