{ config, pkgs, lib, ... }: {
  programs.neovim =
    let pluginWithCfg = config.lib.vimUtils.pluginWithCfg;
    in {
      plugins = with pkgs.vimPlugins; [
        # (pluginWithCfg { plugin = vim-snazzy; file = ./colorscheme.vim; })
        (pluginWithCfg {
          plugin = gruvbox;
          file = ./colorscheme.vim;
        })
        (pluginWithCfg {
          plugin = lualine-nvim;
          file = ./lualine-nvim.lua;
        })
        ({ plugin = telescope-fzf-native-nvim; })
        ({ plugin = nvim-web-devicons; })
        (pluginWithCfg {
          plugin = telescope-nvim;
          file = ./telescope-nvim.lua;
        })
        (pluginWithCfg {
          plugin = nvim-tree-lua;
          file = ./nvim-tree.lua;
        })
        (pluginWithCfg {
          plugin = vista-vim;
          file = ./vista.vim;
        })
      ];
    };
}
