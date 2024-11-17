{
  description = "Rew's Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Commented out until needed
    # stylix = {
    #   url = "github:danth/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # Global variables
    username = "rew";
    homeDirectory = "/home/${username}";
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Common modules used across configurations
    sharedModules = [
      # Base system configuration
      ./system

      # User management
      # home-manager.nixosModules.home-manager
      # {
      #   home-manager = {
      #     useUserPackages = true;
      #     useGlobalPkgs = true;
      #     extraSpecialArgs = {
      #       inherit inputs system username homeDirectory;
      #     };
      #     users.${username} = import ./user;
      #   };
      # }

      # Commented out until needed
      # ./system/style
    ];

    # Function to create host configurations
    mkHost = {
      hostname,
      cpu,
      gpu,
      extraModules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs system username homeDirectory;
          host = hostname;
          # Commented out until needed
          # userSettings = {
          #   theme = "alph";
          #   font = "JetBrains Mono Nerd Font";
          #   fontPkg = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
          # };
        };
        modules =
          [
            ./hosts/${hostname}
          ]
          ++ sharedModules
          ++ extraModules;
      };
  in {
    nixosConfigurations = {
      corvus = mkHost {
        hostname = "corvus";
        cpu = "intel";
        gpu = "nvidia";
      };

      bones = mkHost {
        hostname = "bones";
        cpu = "intel";
        gpu = "intel";
      };
    };

    formatter.${system} = pkgs.alejandra;
  };
}
