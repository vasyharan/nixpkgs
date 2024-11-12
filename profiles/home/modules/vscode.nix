{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions; [
      mkhl.direnv
      eamodio.gitlens
      vscodevim.vim
      jdinhlife.gruvbox
    ];
    userSettings = {
      "workbench.colorTheme" = "Gruvbox Dark Medium";
      "editor.fontFamily" = "'SauceCodePro Nerd Font Mono', monospace";
      "editor.fontSize" = 13;
      "terminal.integrated.fontSize" = 13;
      "editor.minimap.enabled" = false;
      "extensions.ignoreRecommendations" = true;
      "github.copilot.editor.enableAutoCompletions" = true;
      "vim.foldfix" = true;
      "vim.useSystemClipboard" = true;
    };
  };
}

