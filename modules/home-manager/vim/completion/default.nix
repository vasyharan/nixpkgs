{ config, pkgs, lib, ... }: {
  programs.neovim =
    let pluginWithCfg = config.lib.vimUtils.pluginWithCfg;
    in {
      plugins = with pkgs.vimPlugins; [
        { plugin = cmp-nvim-lsp; }
        { plugin = cmp-buffer; }
        { plugin = cmp-path; }
        { plugin = cmp-cmdline; }
        { plugin = cmp-vsnip; }
        { plugin = vim-vsnip; }
        (pluginWithCfg {
          plugin = nvim-cmp;
          file = ./nvim-cmp.lua;
        })
      ];
    };
}

