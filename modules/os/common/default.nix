{ pkgs, ... }: {
  imports = [ ./options.nix ];

  nixpkgs = {
    config = { };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    binaryCaches = [
      https://cache.nixos.org
      https://nix-community.cachix.org
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      kitty
    ];

    variables = {
      TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
    };
  };

  fonts = {
    fontDir.enable = true;
  };

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
