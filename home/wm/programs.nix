{pkgs, ...}: {
  home.packages = with pkgs; [
    nemo
    pamixer
    pavucontrol
    playerctl
  ];
}
