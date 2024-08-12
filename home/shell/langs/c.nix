{pkgs, ...}: {
  home.packages = with pkgs; [
    gcc
    cmake
    clang-tools
    ninja
  ];
}
