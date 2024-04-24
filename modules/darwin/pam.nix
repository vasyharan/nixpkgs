# Taken from implementation of enableSudoTouchIDAuth
# https://github.com/LnL7/nix-darwin/blob/1e706ef323de76236eb183d7784f3bd57255ec0b/modules/security/pam.nix
{ config, lib, pkgs, ... }:
let inherit (lib) mkEnableOption mkOption types;
  cfg = config.security.pam;

  # Implementation Notes
  #
  # We don't use `environment.etc` because this would require that the user manually delete
  # `/etc/pam.d/sudo` which seems unwise given that applying the nix-darwin configuration requires
  # sudo. We also can't use `system.patchs` since it only runs once, and so won't patch in the
  # changes again after OS updates (which remove modifications to this file).
  #
  # As such, we resort to line addition/deletion in place using `sed`. We add a comment to the
  # added line that includes the name of the option, to make it easier to identify the line that
  # should be deleted when the option is disabled.
  mkSudoReattachAuthScript = isEnabled:
    let
      file = "/etc/pam.d/sudo";
      option = "security.pam.enableSudoReattachAuth";
    in
    ''
      ${if isEnabled then ''
        # Enable sudo Touch ID authentication, if not already enabled
        if ! grep 'pam_reattach.so' ${file} > /dev/null; then
          sed -i "" '2i\
        auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh # nix-darwin: ${option}
          ' ${file}
        fi
      '' else ''
        # Disable sudo Touch ID authentication, if added by nix-darwin
        if grep '${option}' ${file} > /dev/null; then
          sed -i "" '/${option}/d' ${file}
        fi
      ''}
    '';
in
{
  options = {
    security.pam.enableSudoReattachAuth = mkEnableOption ''
      Enable sudo authentication reattach (for tmux)
      When enabled, this option adds the following line to /etc/pam.d/sudo:
          auth       optional       \${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
      (Note that macOS resets this file when doing a system update. As such, sudo
      authentication with Touch ID won't work after a system update until the nix-darwin
      configuration is reapplied.)
    '';
  };

  config = {
    system.activationScripts.extraActivation.text = ''
      # PAM settings
      echo >&2 "setting up pam..."
      ${mkSudoReattachAuthScript cfg.enableSudoReattachAuth}
    '';
  };
}
