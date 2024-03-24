{ config, pkgs, lib, ... }: {
  programs.neovim = let
    inherit (lib.vimUtils ./.) pluginWithCfg pluginWithLua;
  in {
    plugins = with pkgs.vimPlugins;
      [
        (pluginWithLua { plugin = nvim-treesitter; })
      ];
  };
}

