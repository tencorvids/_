{pkgs, ...}: {
  home.packages = with pkgs; [
    firefox
    obsidian
    openvpn
    nmap
    vesktop
  ];
}
