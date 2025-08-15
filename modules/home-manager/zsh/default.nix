{ config, pkgs, lib, ... }: {
  home.file = {
    starship = {
      source = ../../../dotfiles/starship.toml;
      target = ".config/starship.toml";
    };
    docker-compose-completion = {
      source = ../../../dotfiles/zsh/completion/_docker-compose;
      target = ".config/zsh/completion/_docker-compose";
    };
  };

  programs.zsh =
    let
      mkZshPlugin = { pkg, file ? "${pkg.pname}.plugin.zsh" }: rec {
        name = pkg.pname;
        src = pkg.src;
        inherit file;
      };
    in
    {
      enable = true;
      dotDir = ".config/zsh";
      initContent = lib.mkMerge [
        (lib.mkBefore ''
          ${builtins.readFile(./settings-first.zsh)}
        '')
        (lib.mkAfter ''
          ${builtins.readFile(./settings.zsh)}
        '')
      ];
      history = {
        size = 10000;
        save = 10000;
        ignoreDups = true;
        ignoreSpace = true;
        extended = true;
        share = true;
      };
      enableCompletion = true;
      completionInit = ''
        autoload -Uz compinit
        for dump in $XDG_CONFIG_HOME/zsh/.zcompdump(N.mh+24); do
          compinit
        done
        compinit -C
      '';
      autosuggestion = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
      };
      shellAliases = {
        g = "git";
        ll = "ls -l";
        la = "ls -a";
        dh = "dirs -v";
        todos = "rg -u 'todo[^:]*haran'";
        vim = "nvim";
      };
      dirHashes = {
        docs = "$HOME/Documents";
        src = "$HOME/src";
      };
      plugins = with pkgs; [
        # (mkZshPlugin { pkg = zsh-powerlevel10k; file = "powerlevel10k.zsh-theme"; })
      ];
    };
}
