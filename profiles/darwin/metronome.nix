{ pkgs, ... }: {
  user.name = "haran";
  home = {
    imports = [
      ../home/modules/git.metronome.nix
      ../home/modules/kitty.nix
      ../home/modules/vscode.nix
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      awscli2
      aws-iam-authenticator
      substrate-tools
      quikstrate
      confluent-cli
      kcat
      kubectl
      nodejs_18
      tilt
      _1password

      eza
      bat
      tree
      fd
      jq
      yq
    ];
  };

  home.programs.zsh = {
    shellAliases = {
      cat = "bat";
      ls = "exa";
      find = "fd";
    };
    sessionVariables = {
      SUBSTRATE_ROOT = "$HOME/src/metronome/metronome-substrate";
      SUBSTRATE_FEATURES = "IgnoreMacOSKeychain";
    };
  };
}

