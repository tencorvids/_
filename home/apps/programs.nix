{pkgs, ...}: {
  home.packages = with pkgs; [
    discord
    firefox
    obsidian
    nmap
    rpi-imager
  ];
}
