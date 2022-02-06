self: super:
let
  inherit (super) lib fetchFromGitHub vimPlugins vimUtils;
in
{
  vimPlugins = vimPlugins // {
    vim-solarized8 = vimUtils.buildVimPluginFrom2Nix rec {
      pname = "vim-solarized8";
      version = "1.2.0";
      src = fetchFromGitHub {
        owner = "lifepillar";
        repo = "vim-solarized8";
        rev = "v${version}";
        sha256 = "sha256-LDH3VJ5l2FF+e0hjxlnwvdw8G2+CXf9n3FpGIIOqac0=";
      };
      meta.homepage = "https://github.com/lifepillar/vim-solarized8";
    };

    vim-snazzy = vimUtils.buildVimPluginFrom2Nix rec {
      pname = "vim-snazzy";
      version = "d979964b4dc0d6860f0803696c348c5a912afb9e";
      src = fetchFromGitHub {
        owner = "connorholyday";
        repo = "vim-snazzy";
        rev = version;
        sha256 = "sha256-6YZUHOqqNP6V4kUEd24ClyMJfckvkQTYRtcVsBsiNSk=";
      };
      meta.homepage = "https://github.com/connorholyday/vim-snazzy";
    };

    nvim-dap-go = vimUtils.buildVimPluginFrom2Nix rec {
      pname = "nvim-dap-go";
      version = "84c109ab994e241feee1d195f2e7c23834101a93";
      src = fetchFromGitHub {
        owner = "leoluz";
        repo = "nvim-dap-go";
        rev = version;
        sha256 = "sha256-x+xoYECsrXPB+pR1ljvjwZvC7rYkzyRm886xoxJP+D4=";
      };
      meta.homepage = "https://github.com/leoluz/nvim-dap-go";
    };

  };
}
