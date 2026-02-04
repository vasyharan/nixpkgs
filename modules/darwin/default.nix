{ config, lib, pkgs, ... }: {
  imports = [ ./pam.nix ./user.nix ./preferences.nix ];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      auto-optimise-store = false # https://github.com/NixOS/nix/issues/7273
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
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  user = {
    home = "/Users/${config.user.name}";
    shell = pkgs.zsh;
  };

  fonts = {
    packages = [
      pkgs.nerd-fonts.sauce-code-pro
    ];
  };

  home = {
    imports = [ ../home-manager ];
    xdg.configFile = {
      ghostty = {
        source = ../../dotfiles/ghostty;
        recursive = true;
      };
    };
  };

  system.stateVersion = 5;
  system.primaryUser = config.user.name;
}
