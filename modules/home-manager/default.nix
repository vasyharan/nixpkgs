{ pkgs, ... }: {
  imports = [ ./zsh ./tmux ./vim ];

  xdg.enable = true;

  home.stateVersion = "22.05";
  home.sessionVariables = { EDITOR = "vim"; };

  home.file = {
    ripgreprc = {
      source = ../../dotfiles/ripgreprc;
      target = ".ripgreprc";
    };
  };

  home.packages = with pkgs; [
    source-code-pro
    fira-code
    inconsolata
    (nerdfonts.override {
      fonts = [ "FiraCode" "Inconsolata" "SourceCodePro" ];
    })

    coreutils
    ripgrep
    jq
    gnupg
    exa
    bat
    tree
    fd
    html-tidy
  ];

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
      ignores = [ "Session.vim" ".direnv/" ".envrc" ];
      extraConfig = {
        init = { defaultBranch = "main"; };
        delta = { navigate = true; };
        help = { autocorrect = 1; };
      };
    };
  };
}
