self: super: {
  vimPlugins = super.vimPlugins // {
    vim-snazzy = super.vimUtils.buildVimPlugin rec {
      pname = "vim-snazzy";
      version = "d979964b4dc0d6860f0803696c348c5a912afb9e";
      src = super.fetchFromGitHub {
        owner = "connorholyday";
        repo = "vim-snazzy";
        rev = version;
        hash = "sha256-6YZUHOqqNP6V4kUEd24ClyMJfckvkQTYRtcVsBsiNSk=";
      };
      meta.homepage = "https://github.com/connorholyday/vim-snazzy";
    };

    trouble-nvim-dev = super.vimUtils.buildVimPlugin rec {
      pname = "trouble.nvim";
      version = "v3.6.0";
      src = super.fetchFromGitHub {
        owner = "folke";
        repo = "trouble.nvim";
        rev = "v3.6.0";
        hash = "sha256-OZRHGcCDgdby5CfR8M0zYkmdxIr5QGaiD/VLeNxAt3s=";
      };
      meta.homepage = "https://github.com/folke/trouble.nvim/";
    };
  };

}
