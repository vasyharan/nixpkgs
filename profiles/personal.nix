{ pkgs, ... }: {
  user.name = "haran";

  home.programs = {
    git = {
      userName = "Thirukumaran Vaseeharan";
      userEmail = "vasyharan@gmail.com  ";
    };
    zsh = {
      dirHashes = {
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
    ];

    variables = {
    };
  };
}

