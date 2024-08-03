{pkgs, ...}: {
  home.packages = with pkgs; [
    btop
    bat
    eza
    fd
    fzf
    ripgrep
    lazygit
    wl-clipboard
    cliphist
    unzip
    just
    flyctl
  ];
}
