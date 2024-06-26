{ config, pkgs, lib, ... }: {
  programs.neovim =
    let
      inherit (lib.vimUtils ./.) pluginWithCfg pluginWithLua;
    in
    {
      plugins = with pkgs.vimPlugins;
        [
          (pluginWithCfg { plugin = gruvbox-nvim; file = "colorscheme"; })

          (pluginWithLua { plugin = lualine-nvim; })
          ({ plugin = telescope-fzf-native-nvim; })
          (pluginWithLua { plugin = telescope-nvim; })
          (pluginWithLua { plugin = nvim-tree-lua; file = "nvim-tree"; })
          (pluginWithCfg { plugin = vista-vim; file = "vista"; })
        ];
    };
}
