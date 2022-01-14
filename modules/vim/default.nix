{ config, pkgs, lib, ... }: {
  imports = [ ./ui ./treesitter ];
  home.programs.neovim = let 
    inherit (lib.vimUtils ./.) readVimSection readLuaSection pluginWithLua;
  in {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      ${readVimSection "settings"}
      ${readLuaSection "keymap"}
    '';
    plugins = with pkgs.vimPlugins;
      [
        { plugin = vim-fugitive; }
        { plugin = vim-rhubarb; }
        { plugin = vim-repeat; }
        { plugin = vim-surround; }
        { plugin = vim-obsession; }

        { plugin = vim-visualstar; }
        { plugin = vim-swap; }
        { plugin = targets-vim; }

        (pluginWithLua { plugin = kommentary; })
      ];
  };
}
