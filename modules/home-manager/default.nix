{ pkgs, ... }: {
  imports = [ ./zsh ./vim ./zellij ];

  home = {
    stateVersion = "22.05";
    sessionVariables = {
      EDITOR = "vim";
    };
    packages = with pkgs; [
      starship
      ripgrep
      unixtools.watch
    ];
  };

  xdg = {
    enable = true;
  };

  xdg.configFile = {
    "ripgrep/ripgreprc" = {
      source = ../../dotfiles/ripgreprc;
    };
  };

  programs = {
    home-manager.enable = true;
    fzf.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    zellij = {
      enable = true;
    };
    jujutsu = {
      enable = true;
      settings = {
        ui = {
          pager = ":builtin";
        };
        colors = {
          "diff token" = {
            underline = false;
          };
          "diff removed token" = {
            bg = "#cc241d";
            fg = "#ebdbb2";
          };
          "diff added token" = {
            bg = "#98971a";
            fg = "#fbf1c7";
          };
        };
      };
    };
    git = {
      enable = true;
      delta = { enable = true; };
      aliases = {
        st = "status";
        co = "checkout";
        cb = "checkout -b";
      };
      ignores = [ ".DS_Store" "tf.plan" ];
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        delta = {
          navigate = true;
        };
        help = {
          autocorrect = 1;
        };
      };
    };
  };
}
