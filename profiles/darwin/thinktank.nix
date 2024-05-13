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
          window_padding_width = 4;
          macos_option_as_alt = true;
          macos_show_window_title_in = "menubar";
          macos_window_resizable = true;
          hide_window_decorations = "titlebar-only";
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
          rust-lang.rust-analyzer
          vadimcn.vscode-lldb
        ];
        userSettings = {
          "workbench.colorTheme" = "Solarized Dark";
          "editor.fontFamily" = "'Inconsolata Nerd Font Mono', monospace";
          "editor.fontSize" = 13;
          "terminal.integrated.fontSize" = 13;
          "editor.minimap.enabled" = false;
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
      jq
    ];
  };

  home.programs.zsh = {
    shellAliases = {
      cat = "bat";
      ls = "exa";
    };
  };
}


