{ config, pkgs, lib, ... }: {
  programs.neovim =
    let
      inherit (lib.vimUtils ./.) pluginWithLua;
    in
    {
      plugins = with pkgs.vimPlugins; [
        (pluginWithLua {
          plugin = (nvim-treesitter.withPlugins (p: [
            p.bash
            p.go
            p.graphql
            p.hcl
            p.java
            p.javascript
            p.jsonnet
            p.lua
            p.markdown
            p.nix
            # p.org
            p.python
            p.rust
            p.scala
            p.svelte
            p.toml
            p.typescript
          ]));
        })
      ];
    };
}

