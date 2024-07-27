{pkgs, ...}: {
  home.packages = with pkgs; [
    lua
    stylua
    lua-language-server
  ];
}
