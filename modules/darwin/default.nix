{ config, lib, pkgs, ... }: {
  imports = [ ./user.nix ./preferences.nix ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    settings = {
      substituters = [
        https://cache.nixos.org
        https://nix-community.cachix.org
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  programs.zsh.enable = true;
  home.imports = [ ../home-manager ];
  user = {
    home = "/Users/${config.user.name}";
    shell = pkgs.zsh;
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override { fonts = [ "Inconsolata" "SourceCodePro" ]; })
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
