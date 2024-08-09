{...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "IBMPlexMono Nerd Font:weight=bold:size=14";
        line-height = 25;
        fields = "name,generic,comment,categories,filename,keywords";
        terminal = "kitty";
        prompt = "' >  '";
        # icon-theme = "Papirus-Dark";
        layer = "top";
        lines = 10;
        width = 35;
        horizontal-pad = 25;
        inner-pad = 5;
      };
      colors = {
        background = "222222ff";
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "b4befeaa";
        selection-match = "f38ba8ff";
        selection-text = "cdd6f4ff";
        border = "ffffffff";
      };
      border = {
        radius = 0;
        width = 4;
      };
    };
  };
}
