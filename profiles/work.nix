{ config, lib, pkgs, ... }: {
  user = {
    name = "haran";
    home = "/Users/haran";
  };

  home.programs.git = {
    userName = "Thirukumaran Vaseeharan";
    userEmail = "haran.thirukumaran@particlehealth.com";
    lfs = {
      enable = true;
    };
    extraConfig = {
      /* "filter \"lfs\"" = {
        smudge = "git-lfs smudge -- %f";
        clean = "git-lfs clean -- %f";
        process = "git-lfs filter-process";
        required = true;
      }; */
    };
  };

  home.programs.zsh = {
    dirHashes = {
      quark = "$HOME/src/quark";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      openjdk17
    ];

    variables = {
      JDK_HOME = "${pkgs.openjdk17.home}";
      JAVA_HOME = "${pkgs.openjdk17.home}";
    };
  };
}
