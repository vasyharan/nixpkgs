{ pkgs, ... }: {
  user.name = "haran";
  home = {
    imports = [
      ../home/modules/git.metronome.nix
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

      inetutils

      # k8s
      kubectl
      argo-rollouts
      kubectx
      k9s

      _1password-cli
      yubikey-manager
      graphite-cli
      postgresql

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
          return 1;
        fi
        eval $credentials
      }
      aws-logout() {
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
        unset AWS_SESSION_TOKEN
      }
      aws-assume() {
        set -o pipefail
        aws-login
        credentials=$(quikstrate assume -e $1 -d $2)
        if [[ $? -ne 0 ]]; then
          return 1;
        fi
        eval $credentials
      }
      kubectx() {
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
      PATH = "$HOME/src/metronome/mkcat/bin:$PATH";
    };
  };
}
