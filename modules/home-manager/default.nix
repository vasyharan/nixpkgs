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
      ripgrep
    ];
  };

  xdg = {
    enable = true;
  };

  xdg.configFile = let 
    zjstatus-bar = ''pane size=1 borderless=true {
      plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
        format_left  "#[bg=blue,fg=black]#[bg=blue,fg=black] {session} {mode} #[fg=default,bg=default]{swap_layout} {tabs}"
        format_right ""
        format_space ""

        mode_normal        "#[bg=blue] #[fg=blue]"
        mode_tmux          "#[bg=green]  "
        mode_locked        "#[bg=red]  "
        mode_default_to_mode "tmux"

        tab_active               "{fullscreen_indicator}{sync_indicator}{floating_indicator}"
        tab_fullscreen_indicator "□ "
        tab_sync_indicator       " "
        tab_floating_indicator   "󰉈 "
      }
    }'';
  in {
    "zellij/config.kdl".source = ../../dotfiles/zellij/config.kdl;

    "zellij/layouts/default.swap.kdl".source = ../../dotfiles/zellij/swap-layouts.kdl;
    "zellij/layouts/default.kdl".text = ''layout {
        default_tab_template {
          ${zjstatus-bar}
          children
        }
        swap_tiled_layout name="stacked" {
          tab min_panes=2 {
            pane split_direction="vertical" {
              pane size="65%" command="nvim"
              pane size="35%" stacked=true {
                children
              }
            }
          }
        }
      }'';

    "zellij/layouts/editor.swap.kdl".source = ../../dotfiles/zellij/swap-layouts.kdl;
    "zellij/layouts/editor.kdl".text = ''layout {
        tab focus=true {
          ${zjstatus-bar}
          pane split_direction="vertical" {
            pane command="nvim"
          }
        }
        swap_tiled_layout name="stacked" {
          tab min_panes=3 {
            ${zjstatus-bar}
            pane split_direction="vertical" {
              pane size="65%" command="nvim"
              pane size="35%" stacked=true {
                children
              }
            }
          }
        }
      }'';

    "zellij/layouts/rust.swap.kdl".source = ../../dotfiles/zellij/swap-layouts.kdl;
    "zellij/layouts/rust.kdl".text = ''layout {
        tab focus=true {
          ${zjstatus-bar}
          pane split_direction="vertical" {
            pane size="65%" command="nvim"
            pane size="35%" stacked=true {
              pane command="cargo" expanded=true {
                args "test"
                start_suspended true
              }
            }
          }
        }
        swap_tiled_layout name="stacked" {
          tab min_panes=3 {
            ${zjstatus-bar}
            pane split_direction="vertical" {
              pane size="65%" command="nvim"
              pane size="35%" stacked=true {
                children
              }
            }
          }
        }
      }'';
  };

  programs = {
    home-manager.enable = true;
    fzf.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zellij = {
      enable = true;
    };

    git = {
      enable = true;
      delta = { enable = true; };
      aliases = {
        st = "status";
        co = "checkout";
        cb = "checkout -b";
      };
      ignores = [];
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
