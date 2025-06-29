{
  description = "Darwin + Home Manager configuration with Fish shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew }: {
    darwinConfigurations = {
      "mates-macbook" = nix-darwin.lib.darwinSystem {
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mate = import ./home;
            
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "mate";
              autoMigrate = true;
            };
          }
          {
            system.configurationRevision = self.rev or self.dirtyRev or null;
          }
        ];
      };
    };
  };
}