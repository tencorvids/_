{pkgs, ...}: {
  home.packages = with pkgs; [
    btop
    bat
    eza
    lazygit
  ];
}
