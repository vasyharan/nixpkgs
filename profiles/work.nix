{ config, lib, pkgs, ... }: {
  user = {
    name = "haran";
    home = "/Users/haran";
  };

  home.programs.git = {
    userName = "Thirukumaran Vaseeharan";
    userEmail = "haran.thirukumaran@particlehealth.com";
  };
  home.programs.zsh = {
    dirHashes = {
      quark = "$HOME/src/quark";
    };
  };
}
