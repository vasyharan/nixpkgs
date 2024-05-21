{ pkgs, ... }: {
  user.name = "haran";
  home = {
    imports = [
      ../home/modules/git.personal.nix
      ../home/modules/kitty.nix
      ../home/modules/vscode.nix
    ];
  };

  environment = {
    systemPackages = with pkgs; [
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
    };
  };
}
