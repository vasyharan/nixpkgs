{ pkgs, ... }: {
  home.programs = {
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
      # keybindings = {
      #   "cmd+k" = "no_op";
      # };
    };
  };
}


