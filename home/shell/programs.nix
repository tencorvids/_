{pkgs, ...}: {
  home.packages = with pkgs; [
    awscli
    btop
    bat
    docker
    steam-run
    eza
    fd
    fzf
    ripgrep
    lazygit
    wl-clipboard
    # cliphist
    (cliphist.overrideAttrs (oldAttrs: {
      doCheck = false;
    }))
    unzip
    just
    flyctl
    imv
    sshpass
    sshfs
    yazi
    steam-run
  ];
}
