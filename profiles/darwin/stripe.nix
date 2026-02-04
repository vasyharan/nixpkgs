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
    etc = {
      "bashrc".enable = false;
      "zshrc".enable = false;
      "zprofile".enable = false;
    };
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
    initContent = ''
      # if [[ -f ~/.stripe/shellinit/zshrc ]]; then
      #  source ~/.stripe/shellinit/zshrc
      # fi
    '';
    dirHashes = {
      metronome = "$HOME/stripe/metronome";
      stripe = "$HOME/stripe";

      kafka = "$HOME/stripe/metronome/kafka";
      mri = "$HOME/stripe/metronome/metering-rating-invoicing-service";
      substrate = "$HOME/stripe/metronome/substrate";
    };
    sessionVariables = {
      SUBSTRATE_ROOT = "$HOME/stripe/metronome/substrate";
      SUBSTRATE_FEATURES = "IgnoreMacOSKeychain";
      PATH = "$HOME/stripe/metronome/mkcat/bin:$HOME/stripe/metronome/migrations/bin:$PATH";
    };
    siteFunctions = {
      mkcd = ''
        mkdir --parents "$1" && cd "$1"
      '';
      aws-login = ''
        set -o pipefail
        credentials=$(quikstrate credentials)
        if [[ $? -ne 0 ]]; then
          return 1;
        fi
        eval $credentials
      '';
      aws-logout = ''
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
        unset AWS_SESSION_TOKEN
      '';
      aws-assume = ''
        set -o pipefail
        aws-login
        credentials=$(quikstrate assume -e $1 -d $2)
        if [[ $? -ne 0 ]]; then
          return 1;
        fi
        eval $credentials
      '';
      aws-console = ''
        set -o pipefail

        aws-login
        account=""
        if [[ $1 == "management" || $1 == "audit" || $1 == "deploy" || $1 == "network" ]]; then
          filter=".Accounts[] | select(.Tags.SubstrateSpecialAccount==\"$1\") | .Id"
        elif [[ $1 == "substrate" ]]; then
          filter=".Accounts[] | select(.Tags.Domain==\"admin\" and .Tags.Environment==\"admin\") | .Id"
        else
          filter=".Accounts[] | select(.Tags.Environment==\"$1\" and .Tags.Domain==\"$2\") | .Id"
        fi

        account=$(quikstrate accounts --format=json | jq -r $filter)
        if [[ $account == "" ]]
        then
          echo "Usage: aws-console (staging|prod <domain>)|management|substrate|audit|deploy|network"
          return 1
        else
          open "https://gnome.house/accounts?number=$${account}&role=Administrator"
        fi
      '';
      kubectx = ''
        declare -A cluster_to_project
        cluster_to_project=( [rating]=ingest [dagster]=lakehouse )
        project=''${cluster_to_project[$2]}
        if [[ -z $project ]]; then
          project=$2
        fi
        aws-assume $1 $project
        command kubectx $1-$2
      '';
      grafana-wtf = ''
        if [[ -z $GRAFANA_TOKEN ]]; then
          echo "Please set GRAFANA_TOKEN environment variable"
          return 1
        fi
        docker run --rm -it -v /tmp/grafana-wtf:/root/.cache \
          --env GRAFANA_URL="https://g-614e59cd65.grafana-workspace.us-west-2.amazonaws.com" \
          --env GRAFANA_TOKEN="''${GRAFANA_TOKEN}" \
          ghcr.io/grafana-toolbox/grafana-wtf grafana-wtf $@
      '';
      migrations = ''
        local SERVICES=("postgres-metadata" "postgres-main" "postgres-notifications" "postgres-aggregates" "postgres-aggregates-0000" "postgres-aggregates-0001")
        case $1 in
          up)
            shift
            set -x
            docker compose --project-directory "$HOME/stripe/metronome/migrations" up -d --wait "''${SERVICES[@]}" "$@"
            ;;
          down)
            shift
            set -x
            docker compose --project-directory "$HOME/stripe/metronome/migrations" down "''${SERVICES[@]}" "$@"
            ;;
          *)
            echo "Usage: migrations [up|down] [extra services]"
            return 1
            ;;
        esac
      '';
    };
  };

  security.pam.services.sudo_local.enable = false;
}
