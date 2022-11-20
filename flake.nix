{
  description = "vasyharan's nix configuration";

  inputs = {
    # package repos
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # system management
    darwin = {
      url = "github:kclejeune/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # shell stuff
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, darwin, flake-utils, home-manager, ... }@inputs:
    let
      isDarwin = system:
        (builtins.elem system inputs.nixpkgs.lib.platforms.darwin);
      homePrefix = system: if isDarwin system then "/Users" else "/home";

      # generate a base darwin configuration with the
      # specified hostname, overlays, and any extraModules applied
      mkDarwinConfig =
        { system ? "aarch64-darwin"
        , nixpkgs ? inputs.nixpkgs
        , baseModules ? [
            home-manager.darwinModules.home-manager
            # ./modules/darwin
          ]
        , extraModules ? [ ]
        ,
        }:
        inputs.darwin.lib.darwinSystem {
          inherit system;
          modules = baseModules ++ extraModules;
          specialArgs = { inherit self inputs nixpkgs; };
        };

      # generate a home-manager configuration usable on any unix system
      # with overlays and any extraModules applied
      mkHomeConfig =
        { username
        , system ? "x86_64-linux"
        , nixpkgs ? inputs.nixpkgs
        , baseModules ? [
            ./modules/home-manager
            {
              home = {
                inherit username;
                homeDirectory = "${homePrefix system}/${username}";
                sessionVariables = {
                  NIX_PATH =
                    "nixpkgs=${nixpkgs}:unstable=${inputs.unstable}\${NIX_PATH:+:}$NIX_PATH";
                };
              };
            }
          ]
        , extraModules ? [ ]
        ,
        }:
        inputs.home-manager.lib.homeManagerConfiguration rec {
          pkgs = import nixpkgs {
            inherit system;
            overlays = builtins.attrValues self.overlays;
          };
          extraSpecialArgs = { inherit self inputs nixpkgs; };
          modules = baseModules ++ extraModules;
        };
    in
    {
      darwinConfigurations = {
        "haran@thinktank" = mkDarwinConfig {
          system = "aarch64-darwin";
          extraModules = [ ./profiles/personal.nix ];
        };
      };

      homeConfigurations = {
        "haran@winny" = mkHomeConfig {
          username = "haran";
          system = "x86_64-linux";
          extraModules = [ ./profiles/personal.nix ];
        };
      };

      overlays = {
        channels = final: prev: {
          # expose other channels via overlays
          unstable = import inputs.unstable { system = prev.system; };
        };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues self.overlays;
        };
      in
      {
        devShells.default = import ./shell.nix { inherit pkgs; };
        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
