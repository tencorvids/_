{pkgs, ...}: {
  home.packages = with pkgs; [
    google-chrome
    firefox
    godot_4
    obsidian
    openvpn
    nmap
    vesktop
  ];
}
