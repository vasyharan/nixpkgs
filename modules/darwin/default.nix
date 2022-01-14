{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ./preferences.nix
    ../common.nix
  ];

  home = {
    xdg.configFile = {
      karabiner = {
        source = ../../dotfiles/karabiner;
        recursive = true;
      };
    };
  };

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
