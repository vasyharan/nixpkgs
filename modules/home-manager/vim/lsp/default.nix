{ config, pkgs, lib, ... }: {
  programs.neovim =
    let
      inherit (lib.vimUtils ./.) pluginWithCfg pluginWithLua;
    in
    {
      plugins = with pkgs.vimPlugins;
        [
          (pluginWithLua { plugin = nvim-lspconfig; })
          { plugin = nvim-web-devicons; }
          (pluginWithLua { plugin = trouble-nvim; file = "nvim-trouble"; })

          # { plugin = copilot-vim; }
          # { plugin = nvim-jdtls; }
          # { plugin = nvim-metals; }
          # (pluginWithLua { plugin = go-nvim; file = "go-nvim"; })
        ];
    };
}
