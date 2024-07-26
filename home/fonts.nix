{pkgs, ...}: {
  home.packages = [
    pkgs.nerdfonts
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    pkgs.twemoji-color-font
  ];
}
