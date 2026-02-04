{ pkgs, ... }: {
  user.name = "haran";
  home = {
    imports = [
      ../home/modules/git.personal.nix
      ../home/modules/kitty.nix
      ../home/modules/vscode.nix
    ];
    zdg.configFile = {
      karabiner = {
        source = ../../dotfiles/karabiner;
        recursive = true;
      };
    };
  };

  services = {
    karabiner-elements.enable = true;
  };
  environment = {
    systemPackages = with pkgs; [
      colima
      k9s
      kubectl
      (google-cloud-sdk.withExtraComponents ([ google-cloud-sdk.components.gke-gcloud-auth-plugin ]))

      eza
      bat
      tree
      fd
      jq
    ];
  };

  home.programs.zsh = {
    shellAliases = {
      cat = "bat";
      ls = "exa";
      k = "kubectl";
      gc = "gcloud";
    };
  };
}
