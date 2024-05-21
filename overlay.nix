self: super:
let
  inherit (super) lib fetchFromGitHub vimPlugins vimUtils;
in
{
  vimPlugins = vimPlugins // {
    vim-snazzy = vimUtils.buildVimPlugin rec {
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

    trouble-nvim-dev = vimUtils.buildVimPlugin rec {
      pname = "trouble.nvim";
      version = "2024-05-21-dev"; # dev branch
      src = fetchFromGitHub {
        owner = "folke";
        repo = "trouble.nvim";
        rev = "e2185bf6e63ef9bd75f1819f43846e2b0f10953b";
        sha256 = "sha256-VXF+2ZnWAybMpK1dPK2ZhB0clEh/ntp68zklJFOKQlw=";
      };
      meta.homepage = "https://github.com/folke/trouble.nvim/";
    };
  };
}
