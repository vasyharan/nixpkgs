{
  description = "vasyharan's nix configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    flake-parts.url = "github:hercules-ci/flake-parts";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zjstatus = {
      url = "github:dj95/zjstatus/v0.14.1";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixpkgs-metronome = {
      url = "path:/Users/haran/src/metronome/nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };
  outputs = { self, flake-parts, nixpkgs, darwin, home-manager, ... } @inputs:
    let
      lib = nixpkgs.lib.extend
        (final: prev: (import ./lib final) // home-manager.lib);

      inherit (darwin.lib) darwinSystem;

      mkDefaultOverlays = { system }: [
        (import ./overlay.nix)
        (final: prev: { zjstatus = inputs.zjstatus.packages.${system}.default; })
        # https://github.com/LnL7/nix-darwin/issues/1041
        (final: prev: { inherit (inputs.nixpkgs-stable.legacyPackages.${system}) karabiner-elements; })
      ];

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
        , extraOverlays ? [ ]
        }: darwinSystem {
          inherit system;
          modules = [ ({ ... }: { nixpkgs.overlays = mkDefaultOverlays { inherit system; } ++ extraOverlays; }) ]
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
        , extraOverlays ? [ ]
        }:
        inputs.home-manager.lib.homeManagerConfiguration rec {
          inherit lib;
          pkgs = import nixpkgs {
            inherit system;
          };
          extraSpecialArgs = { inherit self inputs nixpkgs; };
          modules = [ ({ ... }: { nixpkgs.overlays = mkDefaultOverlays { inherit system; } ++ extraOverlays; }) ]
            ++ baseModules
            ++ extraModules;
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
      flake = {
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
            extraOverlays = [
              inputs.nixpkgs-metronome.overlays.default
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
      };
      perSystem = { config, system, ... }:
        let
          pkgs = import inputs.nixpkgs { inherit system; };
        in
        {
          formatter = pkgs.nixpkgs-fmt;
        };
    };

}
