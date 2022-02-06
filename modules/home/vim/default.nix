{ config, pkgs, lib, ... }: {
  imports = [ ./ui ./treesitter ./lsp ./completion ./dap ];
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
      ${readLuaSection "trim"}
    '';
    plugins = with pkgs.vimPlugins;
      [
        { plugin = vim-fugitive; }
        { plugin = vim-rhubarb; }
        { plugin = vim-repeat; }
        { plugin = vim-surround; }
        { plugin = vim-obsession; }
        { plugin = vim-easy-align; }

        { plugin = vim-visualstar; }
        { plugin = vim-swap; }
        { plugin = targets-vim; }
        { plugin = vim-bbye; }
        { plugin = vim-speeddating; }

        (pluginWithLua { plugin = orgmode; })
        (pluginWithLua { plugin = kommentary; })
      ];
  };

  home.xdg.configFile."nvim/after/plugin/vim-speeddating.vim" = {
    source = ./vim-speeddating.vim;
  };
}
