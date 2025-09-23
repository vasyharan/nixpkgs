{ config, pkgs, lib, ... }: {
  programs.zellij = {
    enable = true;
  };

  xdg.configFile =
    let
      zjstatus-bar = ''pane size=1 borderless=true {
      plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
        format_left  "{mode} {tabs}"
        format_right "#[italic]{session}{swap_layout}"
        format_space ""

        mode_normal        "#[bg=blue] "
        mode_tmux          "#[bg=green] "
        mode_scroll        "#[bg=red] "
        mode_default_to_mode "tmux"

        swap_layout_format          " ({name})"
        swap_layout_hide_if_empty   "true"

        tab_normal               "{fullscreen_indicator}{floating_indicator}{sync_indicator}"
        tab_active               "#[fg=blue,bold,italic]{fullscreen_indicator}{floating_indicator}{sync_indicator}"
        tab_sync_indicator       " "
        tab_fullscreen_indicator " "
        tab_floating_indicator   "󱂬 "
      }
    }'';
    in
    {
      "zellij/config.kdl".source = ../../../dotfiles/zellij/config.kdl;
      "zellij/layouts/default.swap.kdl".source = ../../../dotfiles/zellij/layouts/default.swap.kdl;
      "zellij/layouts/default.kdl".text = ''layout {
        default_tab_template {
          ${zjstatus-bar}
          children
        }
        swap_tiled_layout name="stacked" {
          tab {
            pane split_direction="vertical" {
              pane size="65%"
              pane size="35%" stacked=true {
                  children
              }
            }
          }
        }
        swap_tiled_layout name="v-even" {
          tab {
            pane split_direction="vertical" {
              pane size="65%"
              pane size="35%" {
                  children
              }
            }
          }
        }
      }'';
    };
}
