{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    theme = "Gruvbox Dark";
    font = {
      name = "SauceCodePro Nerd Font Mono";
      size = 11.0;
    };
    shellIntegration = {
      enableZshIntegration = true;
      mode = "no-title";
    };
    settings = {
      update_check_interval = 0;
      sync_to_monitor = "no";
      window_padding_width = 4;
      macos_option_as_alt = true;
      macos_show_window_title_in = "menubar";
      macos_window_resizable = true;
      hide_window_decorations = "titlebar-only";
      clear_all_shortcuts = true;
      enable_audio_bell = false;
      enabled_layouts = "tall:bias=66;full_size=1;mirrored=false,stack";
    };
    keybindings = {
      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";

      "cmd+n" = "new_os_window";
      "cmd+shift+w" = "close_os_window";
      "cmd+h" = "hide_macos_app";
      "opt+cmd+h" = "hide_macos_other_apps";
      "cmd+m" = "minimize_macos_window";
      "cmd+q" = "quit";

      "cmd+enter" = "launch --cwd=current";
      # "opt+j" = "next_window";
      # "opt+k" = "previous_window";

      "shift+cmd+]" = "next_tab";
      "shift+cmd+[" = "previous_tab";
      "cmd+1" = "goto_tab 1";
      "cmd+2" = "goto_tab 2";
      "cmd+3" = "goto_tab 3";
      "cmd+4" = "goto_tab 4";
      "cmd+5" = "goto_tab 5";
      "cmd+6" = "goto_tab 6";
      "cmd+7" = "goto_tab 7";
      "cmd+8" = "goto_tab 8";
      "cmd+9" = "goto_tab 9";
      "cmd+`" = "goto_tab -1";
      "cmd+t" = "new_tab";
      "cmd+w" = "close_tab";

      "cmd+plus" = "change_font_size all +1.0";
      "cmd+equal" = "change_font_size all +1.0";
      "shift+cmd+equal" = "change_font_size all +1.0";
      "cmd+minus" = "change_font_size all -1.0";
      "shift+cmd+minus" = "change_font_size all -1.0";
      "cmd+0" = "change_font_size all 0";

      "cmd+," = "edit_config_file";
      "ctrl+cmd+," = "load_config_file";
      "opt+cmd+," = "debug_config";

      "ctrl+cmd+f" = "toggle_fullscreen";
      "opt+cmd+s" = "toggle_macos_secure_keyboard_entry";
      "opt+z" = "toggle_layout stack";
    };
  };
}

