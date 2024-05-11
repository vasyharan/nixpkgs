{ pkgs, ... }: {
  user.name = "haran";
  home = {
    imports = [ ../home/modules/git.personal.nix ];
    programs = {
      kitty = {
        enable = true;
        theme = "Snazzy";
        font = {
          name = "SauceCodePro Nerd Font Mono";
          size = 11.0;
        };
        settings = {
          update_check_interval = 0;
          sync_to_monitor = "no";
          window_padding_width = 2;
          macos_option_as_alt = true;
        };
      };
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
  };

  environment = {
    systemPackages = with pkgs; [
      eza
      bat
      tree
      fd
    ];
  };

  home.programs.zsh = {
    shellAliases = {
      cat = "bat";
      ls = "exa";
    };
  };
}


