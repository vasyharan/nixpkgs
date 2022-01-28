self: super:
let
  inherit (super) vimPlugins vimUtils fetchFromGitHub lib;
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
  };
}
