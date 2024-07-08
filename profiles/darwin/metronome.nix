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
      # aws
      awscli2
      aws-iam-authenticator
      amazon-ecr-credential-helper
      substrate
      quikstrate

      confluent-cli
      kcat

      nodejs_18
      terraform
      terraform-ls
      rover
      dbmate

      kubectl
      k9s

      tilt
      _1password
      yubikey-manager

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
      tf = "terraform";
      k = "kubectl";
    };
    dirHashes = {
      devenv = "$HOME/src/metronome/local-development";
      substrate = "$HOME/src/metronome/metronome-substrate";
      kafka = "$HOME/src/metronome/metronome-kafka";
    };
    sessionVariables = {
      SUBSTRATE_ROOT = "$HOME/src/metronome/metronome-substrate";
      SUBSTRATE_FEATURES = "IgnoreMacOSKeychain";
    };
  };
}

