{ pkgs, ... }: {
  user.name = "haran";
  home = {
    imports = [
      ../home/modules/git.metronome.nix
      ../home/modules/kitty.nix
    ];
    home.file = {
      bazel-completion = {
        source = "${pkgs.bazel_7}/share/zsh/site-functions/_bazel";
        target = ".config/zsh/completion/_bazel";
      };
      gh-completion = {
        source = "${pkgs.gh}/share/zsh/site-functions/_gh";
        target = ".config/zsh/completion/_gh";
      };
    };
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
      argo-rollouts
      kubectx
      k9s

      _1password-cli
      yubikey-manager
      graphite-cli
      postgresql
      bazel_7

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
      kns = "kubens";
      kctx = "kubectx";
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
        cluster_to_project=( [rating]=ingest [dagster]=lakehouse )
        project=''${cluster_to_project[$2]}
        if [[ -z $project ]]; then
          project=$2
        fi
        aws-assume $1 $project
        command kubectx $1-$2
      }
      grafana-wtf() {
        if [[ -z $GRAFANA_TOKEN ]]; then
          echo "Please set GRAFANA_TOKEN environment variable"
          return 1
        fi
        docker run --rm -it -v /tmp/grafana-wtf:/root/.cache \
          --env GRAFANA_URL="https://g-614e59cd65.grafana-workspace.us-west-2.amazonaws.com" \
          --env GRAFANA_TOKEN="''${GRAFANA_TOKEN}" \
          ghcr.io/grafana-toolbox/grafana-wtf grafana-wtf $@
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
      SUBSTRATE_ROOT = "$HOME/src/metronome/substrate";
      SUBSTRATE_FEATURES = "IgnoreMacOSKeychain";
    };
  };
}
