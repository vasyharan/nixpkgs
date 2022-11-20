{ config, pkgs, lib, ... }: {
  # imports = [ ./ui ./treesitter ./lsp ./completion ];
  imports = [ ./ui ./treesitter ./lsp ./completion ];
  lib.vimUtils = rec {
    # For plugins configured with lua
    wrapLuaConfig = luaConfig: ''
      lua<<EOF
      ${luaConfig}
      EOF
    '';
    readVimConfig = file:
      if (lib.strings.hasSuffix ".lua" (builtins.toString file)) then
        wrapLuaConfig (builtins.readFile file)
      else
        builtins.readFile file;
    pluginWithCfg = { plugin, file, }: {
      inherit plugin;
      config = readVimConfig file;
    };
  };

  programs.neovim =
    let
      readVimConfig = config.lib.vimUtils.readVimConfig;
      pluginWithCfg = config.lib.vimUtils.readVimConfig;
    in
    {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = ''
        ${readVimConfig ./settings.vim}
        ${readVimConfig ./keymap.lua}
        ${readVimConfig ./trim.lua}
      '';
      plugins = with pkgs.vimPlugins; [
        { plugin = vim-fugitive; }
        { plugin = vim-rhubarb; }
        { plugin = vim-repeat; }
        { plugin = vim-surround; }
        { plugin = vim-obsession; }
        { plugin = vim-easy-align; }

        { plugin = vim-visualstar; }
        { plugin = vim-swap; }
        { plugin = targets-vim; }
        { plugin = vim-bbye; }

        {
          plugin = kommentary;
          config = ''
            lua require('kommentary.config').configure_language("default", { prefer_single_line_comments = true })
          '';
        }
        {
          plugin = toggleterm-nvim;
          config = ''
            lua require("toggleterm").setup()
          '';
        }
      ];
    };
}
