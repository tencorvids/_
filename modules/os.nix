{
  username,
  pkgs,
  ...
}: {
  time.timeZone = "America/New_York";
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true;
      http-connections = 50;
      warn-dirty = false;
      log-lines = 50;
      sandbox = "relaxed";
      trusted-users = ["${username}"];
    };
    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
