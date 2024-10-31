{pkgs, ...}: {
  home.packages = with pkgs; [
    bun
    nodejs_22
    nodePackages."typescript-language-server"
    nodePackages."prettier"
    nodePackages."@astrojs/language-server"
    nodePackages."svelte-language-server"
    nodePackages."@tailwindcss/language-server"
  ];
}
