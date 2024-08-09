{...}: let
  custom = {
    font = "IBMPlexMono Nerd Font";
    font_size = "14px";
    font_weight = "normal";
    text_color = "#ffffff";
    secondary_accent = "#ffffff";
    tertiary_accent = "#ffffff";
    background = "#000000";
    opacity = "1.00";
  };
in {
  programs.waybar.style = ''
    * {
        border: none;
        border-radius: 0px;
        padding: 0;
        margin: 0;
        min-height: 0px;
        font-family: ${custom.font};
        font-weight: ${custom.font_weight};
        opacity: ${custom.opacity};
    }

    window#waybar {
        background: none;
    }

    #workspaces {
        font-size: ${custom.font_size};
        padding-left: 16px;
    }

    #workspaces button {
        color: ${custom.text_color};
        padding-left:  8px;
        padding-right: 8px;
    }

    #workspaces button.empty {
        color: ${custom.text_color};
    }

    #workspaces button.active {
        color: ${custom.text_color};
    }

    #pulseaudio, #network, #clock, #battery {
        font-size: ${custom.font_size};
        color: ${custom.text_color};
    }

    #pulseaudio {
        padding-left: 16px;
        padding-right: 8px;
        margin-left: 8px;
    }

    #battery {
        padding-left: 8px;
        padding-right: 8px;
    }

    #network {
        padding-left: 8px;
        padding-right: 16px;
    }

    #clock {
        padding-left: 8px;
        padding-right: 16px;
    }
  '';
}
