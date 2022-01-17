{ config, lib, pkgs, options, ... }: {
  imports = [ ./user.nix ./zsh ./tmux ./vim ];

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
    systemPackages = with pkgs;
      [
        zsh
        tmux
        neovim
        coreutils
        git
        fzf
        ripgrep
        jq
      ];
    variables = {
    };
  };

  fonts = {
    enableFontDir = true;
  };

  home-manager.useGlobalPkgs = true;
  home = { pkgs, ... }: {
    home = {
      sessionVariables = {
        EDITOR = "vim";
      };
      file = {
        p10k = {
          source = ../dotfiles/p10k.zsh;
          target = ".p10k.zsh";
        };
        ripgreprc = {
          source = ../dotfiles/ripgreprc;
          target = ".ripgreprc";
        };
      };
      packages = with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" "Hack" "InconsolataGo" ]; })
      ];
    };

    xdg = {
      enable = true;
    };

    programs = {
      fzf.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      git = {
        enable = true;
        delta = { enable = true; };
        aliases = {
          st = "status";
          co = "checkout";
          cb = "checkout -b";
        };
        ignores = [
          "Session.vim"
          "shell.nix"
          ".direnv/"
          ".envrc"
        ];
        extraConfig = {
          help = {
            autocorrect = 1;
          };
        };
      };
    };
  };
}
