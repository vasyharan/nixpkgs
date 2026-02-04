{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    # pinned nixpkgs for terraform 1.5.6
    nixpkgs-terraform.url = "github:NixOS/nixpkgs/efd23a1c9ae8c574e2ca923c2b2dc336797f4cc4";
    # pinned nixpkgs for bazel 7.4.1
    nixpkgs-bazel_7_4_1.url = "github:NixOS/nixpkgs/2690be80fdd88926bc65b897f7202adee583d909";
    # pinned nixpkgs for nodejs 18
    nixpkgs-nodejs_18.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
  };

  nixConfig = {
    extra-substituters = [
      https://cache.nixos.org
      https://nix-community.cachix.org
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" ];
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];

      perSystem = { config, system, ... }:
        let
          pkgs = import inputs.nixpkgs { inherit system; };
          pkgs-terraform = import inputs.nixpkgs-terraform { inherit system; };
          pkgs-bazel_7 = import inputs.nixpkgs-bazel_7_4_1 { inherit system; };
          # pkgs-nodejs_18 = import inputs.nixpkgs-nodejs_18 { inherit system; };

          inherit (pkgs) callPackage;

          jdk = pkgs.temurin-bin-17;
          jre = pkgs.temurin-jre-bin-17;
          maven = (pkgs.maven.override { jdk_headless = jdk; });

          packages = {
            inherit jdk maven;
            inherit (pkgs) topicctl;
            inherit (pkgs-terraform) terraform;
            # inherit (pkgs-nodejs_18) nodejs_18;
            inherit (pkgs-bazel_7) bazel_7;
            # update the default nodejs to v20
            nodejs = pkgs.nodejs_24;

            # dbmate = callPackage ./pkgs/dbmate.nix { };
            jmxterm = callPackage ./pkgs/jmxterm.nix { inherit jre maven; };
            kcctl = callPackage ./pkgs/kcctl.nix { };
            quikstrate = callPackage ./pkgs/quikstrate.nix { };
            substrate = callPackage ./pkgs/substrate.nix { };
          };
        in
        {
          formatter = pkgs.nixpkgs-fmt;
          inherit packages;
          overlayAttrs = packages;
        };
    };
}
