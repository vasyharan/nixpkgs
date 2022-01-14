{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ./preferences.nix
    ../common.nix
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;   # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
