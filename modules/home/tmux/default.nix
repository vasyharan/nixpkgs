{ config, pkgs, lib, ... }: {
  home = {
    xdg.configFile."tmux/resize-main-pane.sh" = {
      source = ./resize-main-pane.sh;
    };

    programs.tmux =
      let readFile = file: builtins.readFile (./. + "/${file}");
      in {
        enable = true;
        sensibleOnTop = true;
        prefix = "S-F1";
        keyMode = "vi";
        historyLimit = 50000;
        aggressiveResize = true;
        clock24 = true;
        extraConfig = readFile "tmux.conf";
      };
  };
}

