{pkgs, ...}: {
  home.packages = with pkgs; [
    firefox
    obsidian
  ];
}
