{pkgs, ...}: {
  home.packages = with pkgs; [
    pamixer
    pavucontrol
    playerctl
  ];
}
