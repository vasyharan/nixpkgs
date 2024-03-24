{ pkgs, ... }: {
  imports = [ ./zsh ./tmux ./vim ];

  home = {
    stateVersion = "22.05";
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
      source-code-pro
      fira-code
      inconsolata
      (nerdfonts.override { fonts = [ "FiraCode" "Inconsolata" "SourceCodePro" ]; })

      gcc
      coreutils
      ripgrep
      jq
      gnupg
      eza
      bat
      tree
      fd
      html-tidy
    ];
  };

  xdg = {
    enable = true;
  };

  programs = {
    home-manager.enable = true;
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
