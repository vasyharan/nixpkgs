{ pkgs, ... }: {
  home.programs = {
    vscode = {
      enable = true;
      mutableExtensionsDir = false;
      extensions = with pkgs.vscode-extensions; [
        mkhl.direnv
        vscodevim.vim
        golang.go
        bbenoist.nix
      ];
      userSettings = {
        "workbench.colorTheme" = "Solarized Dark";
        "editor.fontFamily" = "'Inconsolata Nerd Font Mono', monospace";
        "editor.fontSize" = 14;
        "terminal.integrated.fontSize" = 14;
      };
    };
  };
}



