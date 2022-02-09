{ pkgs, ... }: {
  imports = [ ./zsh ./tmux ./vim ];

  home.home = {
    sessionVariables = {
      EDITOR = "vim";
    };
    file = {
      ripgreprc = {
        source = ../../dotfiles/ripgreprc;
        target = ".ripgreprc";
      };
    };
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "Hack" "InconsolataGo" ]; })
    ];
  };

  home.xdg = {
    enable = true;
  };

  home.programs = {
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
        "*.nix"
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
}
