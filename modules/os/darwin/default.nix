{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../common
    ./preferences.nix
  ];

  home = {
    xdg.configFile = {
      karabiner = {
        source = ../../../dotfiles/karabiner;
        recursive = true;
      };
    };
  };
}
