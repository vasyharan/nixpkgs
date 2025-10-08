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
    initContent = ''
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
      aws-console() {
        set -o pipefail

        declare -A env_to_quality
        env_to_quality=( [staging]=alpha [prod]=gamma )

        aws-login
        if [[ $1 == "" ]]; then
          echo "Usage: aws-console (staging|prod <domain>)|management|substrate|audit|deploy|network"
          return 1
        elif [[ $1 == "management" ]]; then
          substrate assume-role -q --management --console
        elif [[ $1 == "substrate" ]]; then
          substrate assume-role -q --substrate --console
        elif [[ $1 == "audit" || $1 == "deploy" || $1 == "network" ]]; then 
          substrate assume-role -q --special=$1 --console
        else
          quality=''${env_to_quality[$1]}
          substrate assume-role -q -d=$2 -e=$1 --quality=$quality --console
        fi
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
      migrations() {
        local SERVICES=("postgres-metadata" "postgres-main" "postgres-notifications" "postgres-aggregates" "postgres-aggregates-0000" "postgres-aggregates-0001")
        case $1 in
          up)
            shift
            set -x
            docker compose --project-directory "$HOME/src/metronome/migrations" up -d --wait "''${SERVICES[@]}" "$@"
            ;;
          down)
            shift
            set -x
            docker compose --project-directory "$HOME/src/metronome/migrations" down "''${SERVICES[@]}" "$@"
            ;;
          *)
            echo "Usage: migrations [up|down] [extra services]"
            return 1
            ;;
        esac
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
      PATH = "$HOME/src/metronome/mkcat/bin:$HOME/src/metronome/migrations/bin:$PATH";
    };
  };
}
