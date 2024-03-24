{
  description = "vasyharan's nix configuration";
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixpkgs-unstable;
    flake-utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs = inputs@{ self, nixpkgs, darwin, home-manager, flake-utils, ... }:
  let
    lib = nixpkgs.lib.extend
      (final: prev: (import ./lib final) // home-manager.lib);

    inherit (darwin.lib) darwinSystem;

    mkDarwinConfiguration =
      { system
      , baseModules ? [
          home-manager.darwinModules.home-manager
          ./modules/os/darwin
          ./modules/home-manager
        ]
      , extraModules ? []
      }: darwinSystem {
        inherit system;
        modules = [ ({ config, pkgs, ... }: { nixpkgs.overlays = [ (import ./overlay.nix) ]; }) ] ++ baseModules ++ extraModules;
        specialArgs = { inherit inputs lib; };
      };

    mkHomeConfig =
      { username
      , homeDirectory
      , system ? "x86_64-linux"
      , nixpkgs ? inputs.nixpkgs
      , stable ? inputs.nixpkgs-stable
      , baseModules ? [
          ./modules/home-manager
          {
            home = {
              inherit username homeDirectory;
              sessionVariables = {
                NIX_PATH =
                  "nixpkgs=${nixpkgs}:stable=${stable}\${NIX_PATH:+:}$NIX_PATH";
              };
            };
          }
        ]
      , extraModules ? [ ]
      }:
      inputs.home-manager.lib.homeManagerConfiguration rec {
        inherit lib;
        pkgs = import nixpkgs {
          inherit system;
        };
        extraSpecialArgs = { inherit self inputs nixpkgs; };
        modules = [ ({ ... }: { nixpkgs.overlays = [ (import ./overlay.nix) ]; }) ] 
          ++ baseModules 
          ++ extraModules;
      };

  in {
      darwinConfigurations = {
        ph-haran-mbp = mkDarwinConfiguration {
          system = "aarch64-darwin";
          extraModules = [
            ./profiles/work.nix
          ];
        };
      };
      homeConfigurations = {
        web0 = mkHomeConfig {
          username = "root";
          homeDirectory = "/root";
          system = "x86_64-linux";
          extraModules = [
            ./profiles/personal.nix
          ];
        };
      };
    } //
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        inherit (pkgs) devShell;
        /* devShell = import ./shell.nix { inherit pkgs; }; */
      });
}
