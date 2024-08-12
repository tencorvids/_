{pkgs, ...}: {
  home.packages = with pkgs; [
    discord
    firefox
    obsidian
    openvpn
    nmap
    rpi-imager
  ];
}
