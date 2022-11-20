{ config, pkgs, lib, ... }: {
  home.programs.neovim =
    let inherit (lib.vimUtils ./.) pluginWithCfg pluginWithLua;
    in {
      plugins = with pkgs.vimPlugins; [
        (pluginWithLua { plugin = nvim-dap; })
        { plugin = nvim-dap-ui; }
        { plugin = nvim-dap-virtual-text; }
        (pluginWithLua { plugin = nvim-dap-go; })
      ];
    };
}
