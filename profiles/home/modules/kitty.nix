{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    theme = "Gruvbox Dark";
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
      clear_all_shortcuts = true;
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

      "shift+cmd+]" = "next_tab";
      "shift+cmd+[" = "previous_tab";
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
    };
  };
}

