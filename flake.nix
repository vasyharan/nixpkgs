{
  description = "vasyharan's nix configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
          ./modules/home
        ]
      , extraModules ? []
      }: darwinSystem {
        inherit system;
        modules = [ ({ config, pkgs, ... }: { nixpkgs.overlays = [ (import ./overlay.nix) ]; }) ] ++ baseModules ++ extraModules;
        specialArgs = { inherit inputs lib; };
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
    } //
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        inherit (pkgs) devShell;
        /* devShell = import ./shell.nix { inherit pkgs; }; */
      });
}
