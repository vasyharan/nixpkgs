{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      eza
      bat
      tree
      fd
    ];
  };

  home.programs.zsh = {
    shellAliases = {
      cat = "bat";
      ls = "exa";
    };
  };
}


