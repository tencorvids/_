{pkgs, ...}: {
  home.packages = with pkgs; [
    firefox
    godot_4
    obsidian
    openvpn
    nmap
    vesktop
  ];
}
