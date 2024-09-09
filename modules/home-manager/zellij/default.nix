{ config, pkgs, lib, ... }: {
  programs.zellij = {
    enable = true;
  };

  xdg.configFile =
    let
      zjstatus-bar = ''pane size=1 borderless=true {
      plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
        format_left  "{mode} {tabs}"
        format_right "{swap_layout} #[italic]{session} "
        format_space ""

        mode_normal        "#[bg=blue] "
        mode_tmux          "#[bg=green] "
        mode_scroll        "#[bg=red] "
        mode_default_to_mode "tmux"

        tab_normal               " {index} {name} {fullscreen_indicator}{sync_indicator}{floating_indicator}"
        tab_active               "#[fg=blue,bold,italic] {index} {name} {fullscreen_indicator}{sync_indicator}{floating_indicator}"
        tab_fullscreen_indicator "□ "
        tab_sync_indicator       " "
        tab_floating_indicator   "󰉈 "
      }
    }'';
    in
    {
      "zellij/config.kdl".source = ../../../dotfiles/zellij/config.kdl;
      "zellij/layouts/default.swap.kdl".source = ../../../dotfiles/zellij/swap-layouts.kdl;
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
    };
}
