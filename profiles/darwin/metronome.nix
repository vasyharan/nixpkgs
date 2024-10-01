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
      mcfly
      mcfly-fzf
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
        set -o pipefail
        credentials=$(quikstrate credentials)
        if [[ $? -ne 0 ]]; then
          exit 1;
        fi
        eval $credentials
      }
      aws-assume() {
        set -o pipefail
        aws-login
        credentials=$(quikstrate assume -e $1 -d $2)
        if [[ $? -ne 0 ]]; then
          exit 1;
        fi
        eval $credentials
      }
      kubectx() {
        declare -A cluster_to_project
        cluster_to_project=( [rating]=ingest )
        project=''${cluster_to_project[$2]}
        if [[ -z $project ]]; then
          project=$2
        fi
        aws-assume $1 $project
        command kubectx $1-$2
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
      substrate = "$HOME/src/metronome/metronome-substrate";
    };
    sessionVariables = {
      SUBSTRATE_ROOT = "$HOME/src/metronome/metronome-substrate";
      SUBSTRATE_FEATURES = "IgnoreMacOSKeychain";
    };
  };
}
