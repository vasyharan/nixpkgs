{ config, pkgs, lib, ... }: {
  programs.neovim =
    let
      inherit (lib.vimUtils ./.) pluginWithCfg pluginWithLua;
    in
    {
      plugins = with pkgs.vimPlugins;
        [
          { plugin = cmp-nvim-lsp; }
          { plugin = cmp-buffer; }
          { plugin = cmp-path; }
          { plugin = cmp-cmdline; }
          { plugin = cmp-vsnip; }
          { plugin = vim-vsnip; }
          (pluginWithLua { plugin = nvim-cmp; })
        ];
    };
}



