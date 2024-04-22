{ config, pkgs, lib, ... }: {
  programs.neovim =
    let
      inherit (lib.vimUtils ./.) pluginWithCfg pluginWithLua;
    in
    {
      plugins = with pkgs.vimPlugins;
        [
          (pluginWithLua { plugin = nvim-lspconfig; })
          { plugin = nvim-jdtls; }
          { plugin = nvim-metals; }
          { plugin = nvim-web-devicons; }
          { plugin = trouble-nvim; }
        ];
    };
}
