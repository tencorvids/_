{pkgs, ...}: {
  home.packages = with pkgs; [
    poetry
    python3
    python3Packages.pip
    python3Packages.virtualenv
    pyright
  ];
}
