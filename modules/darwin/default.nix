{ config, lib, pkgs, ... }: {
  imports = [ ./pam.nix ./user.nix ./preferences.nix ];

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
      trusted-users = [ "root" config.user.name ];
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

  nixpkgs.config.allowUnfree = true;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  services.karabiner-elements.enable = true;
  programs.zsh.enable = true;

  user = {
    home = "/Users/${config.user.name}";
    shell = pkgs.zsh;
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    ];
  };

  home = {
    imports = [ ../home-manager ];
    xdg.configFile = {
      karabiner = {
        source = ../../dotfiles/karabiner;
        recursive = true;
      };
    };
  };


  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
