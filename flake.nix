{
  description = "Rew's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) nixosSystem;
    supportedSystems = ["x86_64-linux"];

    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});

    createNixosConfiguration = {
      system,
      username,
      homeDirectory,
      hostname,
      cpu,
      gpu,
      modules ? [],
    }:
      nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs hyprland username homeDirectory hostname cpu gpu;
        };
        modules =
          [
            ./hosts/${hostname}/configuration.nix
            {networking.hostName = hostname;}
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = false;
                extraSpecialArgs = {inherit inputs hostname;};
                users.${username} = import ./home {
                  inherit (nixpkgsFor.${system}) pkgs;
                  inherit inputs username homeDirectory hostname;
                };
                backupFileExtension = "backup";
              };
            }
            hyprland.nixosModules.default
          ]
          ++ modules;
      };
  in {
    nixosConfigurations = {
      corvus = createNixosConfiguration {
        system = "x86_64-linux";
        username = "rew";
        homeDirectory = "/home/rew";
        hostname = "corvus";
        cpu = "intel";
        gpu = "nvidia";
      };
      bones = createNixosConfiguration {
        system = "x86_64-linux";
        username = "rew";
        homeDirectory = "/home/rew";
        hostname = "bones";
        cpu = "intel";
        gpu = "intel";
      };
    };

    devShells = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          git
          alejandra
          statix
        ];
      };
    });
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
