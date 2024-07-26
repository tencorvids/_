{pkgs, ...}: {
  programs.git = {
    enable = true;

    userName = "rew";
    userEmail = "rew@tencorvids.com";

    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };
}
