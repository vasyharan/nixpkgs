{ config, pkgs, lib, ... }: {
  home.home.file = {
    zsh-completion = {
      source = ../../../dotfiles/zsh/completion;
      target = ".config/zsh/completion";
    };
    p10k = {
      source = ../../../dotfiles/zsh/p10k.zsh;
      target = ".p10k.zsh";
    };
  };

  home.programs.zsh = let
    mkZshPlugin = { pkg, file ? "${pkg.pname}.plugin.zsh" }: rec {
      name = pkg.pname;
      src = pkg.src;
      inherit file;
    };
  in {
    enable = true;
    dotDir = ".config/zsh";
    initExtraFirst = ''
      ${builtins.readFile(./. + "/settings-first.zsh")}
    '';
    initExtra = ''
      ${builtins.readFile(./. + "/settings.zsh")}
    '';
    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      g = "git";
      ls = "ls -G";
      ll = "ls -l";
      la = "ls -a";
      dh = "dirs -v";
      todos = "rg -u 'todo[^:]*haran'";
    };
    dirHashes = {
      docs = "$HOME/Documents";
      src = "$HOME/src";
    };
    plugins = with pkgs; [
      (mkZshPlugin { pkg = zsh-powerlevel10k; file = "powerlevel10k.zsh-theme"; })
    ];
  };
}
