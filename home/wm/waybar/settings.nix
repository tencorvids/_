{...}: {
  programs.waybar.settings.mainBar = {
    position = "bottom";
    layer = "top";
    height = 5;
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;
    modules-left = [
      "hyprland/workspaces"
    ];
    modules-center = [
      "clock"
    ];
    modules-right = [
      "pulseaudio"
      "battery"
      "network"
    ];
    clock = {
      calendar = {
        format = {today = "<span color='#b4befe'><b><u>{}</u></b></span>";};
      };
      format = " {:%I:%M}";
      tooltip = "true";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = " {:%d/%m}";
    };
    "hyprland/workspaces" = {
      active-only = false;
      disable-scroll = true;
      on-click = "activate";
    };
    network = {
      format-wifi = "  {signalStrength}%";
      format-ethernet = "󰀂 ";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "󰖪 ";
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "󰖁  {volume}%";
      format-icons = {
        default = [" "];
      };
      scroll-step = 5;
      on-click = "pamixer -t";
    };
    battery = {
      format = "{icon} {capacity}%";
      format-icons = [" " " " " " " " " "];
      format-charging = " {capacity}%";
      format-full = " {capacity}%";
      format-warning = " {capacity}%";
      interval = 5;
      states = {
        warning = 20;
      };
      format-time = "{H}h{M}m";
      tooltip = true;
      tooltip-format = "{time}";
    };
  };
}
