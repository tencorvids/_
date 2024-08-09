{pkgs, ...}: {
  home.packages = [
    pkgs.nerdfonts
    (pkgs.nerdfonts.override {fonts = ["IBMPlexMono"];})
    pkgs.twemoji-color-font
  ];
}
