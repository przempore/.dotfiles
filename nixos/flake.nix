{
  description = "Przemek's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-alien, ... }:
  let 
      system = "x86_64-linux"; # or aarch64-linux
      pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = inputs;
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # home-manager.users.przemek = import ./home.nix;
            home-manager.users.przemek = import ./home;
          }
        ];
      };
    };
    homeConfigurations.nix-alien-home = home-manager.lib.homeManagerConfiguration rec {
      inherit pkgs;
      extraSpecialArgs = { inherit self system; };
      modules = [
        ({ self, system, ... }: {
          home.packages = with self.inputs.nix-alien.packages.${system}; [
            nix-alien
          ];
        })
      ];
    };
  };
}
