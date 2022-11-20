{ config, pkgs, lib, ... }: {
  programs.neovim =
    let pluginWithCfg = config.lib.vimUtils.pluginWithCfg;
    in {
      plugins = with pkgs.vimPlugins; [
        (pluginWithCfg {
          plugin = nvim-lspconfig;
          file = ./nvim-lspconfig.lua;
        })
        { plugin = nvim-jdtls; }
        { plugin = nvim-metals; }
        { plugin = trouble-nvim; }
      ];
    };
}
