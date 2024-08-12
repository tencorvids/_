{pkgs, ...}: {
  home.packages = with pkgs; [
    discord
    firefox
    obsidian
    rpi-imager
  ];
}
