{pkgs, ...}: {
  home.packages = [
    pkgs.nerdfonts
    (pkgs.nerdfonts.override {fonts = ["IBMPlexMono" "GeistMono"];})
    pkgs.twemoji-color-font
    pkgs.geist-font
  ];
}
