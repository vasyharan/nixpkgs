{ config, pkgs, lib, ... }: {
  programs.neovim =
    let pluginWithCfg = config.lib.vimUtils.pluginWithCfg;
    in {
      plugins = with pkgs.unstable.vimPlugins;
        [
          (pluginWithCfg {
            plugin = nvim-treesitter;
            file = ./nvim-treesitter.lua;
          })
        ];
    };
}

