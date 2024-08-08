{hostname, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;

    initExtra = ''
    '';

    shellAliases = {
      cat = "bat";

      l = "eza --icons  -a --group-directories-first -1";
      ll = "eza --icons  -a --group-directories-first -1 --no-user --long";
      tree = "eza --icons --tree --group-directories-first";

      vi = "nvim";
      vim = "nvim";
      cdvim = "cd ~/_/home/shell/neovim/nvim && nvim ~/_/home/shell/neovim/nvim";

      cdnix = "cd ~/_ && nvim ~/_";
      nix-switch = "sudo nixos-rebuild switch --flake ~/_#${hostname}";
      nix-switch-update = "sudo nixos-rebuild switch --upgrade --flake ~/_#${hostname}";
      nix-full-switch = "sudo nix-collect-garbage -d && sudo nixos-rebuild switch --flake ~/_#${hostname}";
      nix-update = "sudo nix flake update ~/_";

      py = "python";
    };
  };
}
