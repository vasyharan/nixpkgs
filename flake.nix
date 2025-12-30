{
  description = "vasyharan's nix configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zjstatus = {
      url = "github:dj95/zjstatus/v0.22.0";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.flake-utils.follows = "flake-utils";
    };
    starship-jj = {
      url = "gitlab:lanastara_foss/starship-jj/0.7.0";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.flake-utils.follows = "flake-utils";
    };
    nixpkgs-metronome = {
      url = "path:/Users/haran/src/metronome/nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, flake-parts, nixpkgs, darwin, home-manager, ... } @inputs:
    let
      lib = nixpkgs.lib.extend
        (final: prev: (import ./lib final) // home-manager.lib);

      inherit (darwin.lib) darwinSystem;

      mkDefaultOverlays = { system }: [
        # (import ./overlay.nix)
        (final: prev: {
          zjstatus = inputs.zjstatus.packages.${system}.default;
          starship-jj = inputs.starship-jj.packages.${system}.default;
          # https://github.com/LnL7/nix-darwin/issues/1041
          # karabiner-elements = inputs.nixpkgs-stable.legacyPackages.${system}.karabiner-elements;
          karabiner-elements = prev.karabiner-elements.overrideAttrs (attrs: {
            version = "14.13.0";
            src = prev.fetchurl {
              inherit (attrs.src) url;
              hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
            };
          });
        })
      ];

      mkOverrideOverlays = { system }: [
        (final: prev: {
          nodejs = prev.nodejs_22;
        })
      ];

      mkDarwinConfiguration =
        { system
        , nixpkgs ? inputs.nixpkgs
        , unstable ? inputs.nixpkgs
        , stable ? inputs.nixpkgs-stable
        , baseModules ? [
            ./modules/darwin
            home-manager.darwinModules.home-manager
          ]
        , extraModules ? [ ]
        , extraOverlays ? [ ]
        }: darwinSystem {
          inherit system;
          modules = [
            ({ ... }: {
              nixpkgs.overlays = mkDefaultOverlays { inherit system; }
                ++ extraOverlays
                ++ mkOverrideOverlays { inherit system; };
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
