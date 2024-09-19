{pkgs, ...}: {
  home.packages = with pkgs; [
    go
    gopls
    air
  ];

  home.sessionVariables = {
    GOPATH = "$HOME/.local/share/go";
  };

  home.sessionPath = [
    "$GOPATH/bin"
  ];
}
