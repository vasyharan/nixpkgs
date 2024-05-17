{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions; [
      mkhl.direnv
      vscodevim.vim
      golang.go
      bbenoist.nix
      rust-lang.rust-analyzer
      # ms-vscode.cpptools
    ];
    userSettings = {
      "workbench.colorTheme" = "Solarized Dark";
      "editor.fontFamily" = "'SauceCodePro Nerd Font Mono', monospace";
      "editor.fontSize" = 13;
      "terminal.integrated.fontSize" = 13;
      "editor.minimap.enabled" = false;
    };
  };
}

