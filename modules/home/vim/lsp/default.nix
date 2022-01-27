{ config, pkgs, lib, ... }: {
  home.programs.neovim = let
    inherit (lib.vimUtils ./.) pluginWithCfg pluginWithLua;
  in {
    plugins = with pkgs.vimPlugins;
      [
        (pluginWithLua { plugin = nvim-lspconfig; })
        (pluginWithLua { plugin = nvim-jdtls; })
        { plugin = nvim-web-devicons; }
        { plugin = trouble-nvim; }
      ];
  };
}


