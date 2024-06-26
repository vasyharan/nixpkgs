{
  description = "vasyharan's nix configuration";
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixpkgs-unstable;
    flake-utils.url = "github:numtide/flake-utils";
    zjstatus.url = "github:dj95/zjstatus/v0.14.1";

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
        , nixpkgs ? inputs.nixpkgs-unstable
        , unstable ? inputs.nixpkgs-unstable
        , stable ? inputs.nixpkgs-stable
        , baseModules ? [
            ./modules/darwin
            home-manager.darwinModules.home-manager
          ]
        , extraModules ? [ ]
        }: darwinSystem {
          inherit system;
          modules = [
            ({ ... }: {
              nixpkgs.overlays = [
                (import ./overlay.nix)
                (final: prev: {
                  zjstatus = inputs.zjstatus.packages.${system}.default;
                })
              ];
            })
          ]
          ++ baseModules
          ++ extraModules;
          specialArgs = { inherit inputs lib nixpkgs; };
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

    in
    {
      darwinConfigurations = {
        thinktank = mkDarwinConfiguration {
          system = "x86_64-darwin";
          extraModules = [
            ./profiles/darwin/thinktank.nix
          ];
        };
        metronome = mkDarwinConfiguration {
          system = "aarch64-darwin";
          extraModules = [
            ./profiles/darwin/metronome.nix
          ];
        };
      };
      homeConfigurations = {
        web0 = mkHomeConfig {
          username = "root";
          homeDirectory = "/root";
          system = "x86_64-linux";
          extraModules = [
            ./profiles/home/modules/git.personal.nix
          ];
        };
        gitpod = mkHomeConfig {
          username = "gitpod";
          homeDirectory = "/home/gitpod";
          system = "x86_64-linux";
          extraModules = [
            ./profiles/home/modules/git.personal.nix
          ];
        };
      };
    } //
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        inherit (pkgs) devShell;
        formatter = pkgs.nixpkgs-fmt;
      });
}
