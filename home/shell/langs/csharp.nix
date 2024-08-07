{pkgs, ...}: {
  home.packages = with pkgs; [
    dotnetCorePackages.sdk_8_0
    csharp-ls
  ];
}
