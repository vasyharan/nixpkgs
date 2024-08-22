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

      # k8s
      kubectl
      kubectx
      k9s

      _1password
      yubikey-manager
      graphite-cli
      colima

      gh
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
      dc = "docker compose";
      qs = "quikstrate";
    };
    initExtra = ''
      aws-login() {
        eval $(quikstrate credentials)
      }
      aws-assume() {
        eval $(quikstrate assume -e $1 -d $2)
      }
    '';
    dirHashes = {
      work = "$HOME/src/metronome";

      devenv = "$HOME/src/metronome/local-development";
      charts = "$HOME/src/metronome/charts";
      frontend = "$HOME/src/metronome/frontend";
      gateway = "$HOME/src/metronome/graphql-gateway";
      resolvers = "$HOME/src/metronome/graphql-resolvers";
      kafka = "$HOME/src/metronome/kafka";
      mri = "$HOME/src/metronome/metering-rating-invoicing-service";
      substrate = "$HOME/src/metronome/substrate";
    };
    sessionVariables = {
      SUBSTRATE_ROOT = "$HOME/src/metronome/substrate";
      SUBSTRATE_FEATURES = "IgnoreMacOSKeychain";
    };
  };
}

