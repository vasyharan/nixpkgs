{ config, pkgs, lib, ... }: {
  home.programs.neovim = let
    inherit (lib.vimUtils ./.) pluginWithCfg pluginWithLua;
  in {
    plugins = with pkgs.vimPlugins;
      [
        ({ plugin = vim-solarized8; })
        ({ plugin = nord-nvim; })
        ({ plugin = vim-snazzy; })
        (pluginWithCfg { plugin = NeoSolarized; file = "colorscheme"; })
        (pluginWithLua { plugin = lsp-status-nvim; })
        (pluginWithLua { plugin = lualine-nvim; })
        ({ plugin = telescope-fzf-native-nvim; })
        (pluginWithLua { plugin = telescope-nvim; })
        (pluginWithLua { plugin = nvim-tree-lua; file = "nvim-tree"; })
      ];
  };
}
