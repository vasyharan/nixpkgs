{ ... }:
{
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      orientation = "right";
      tilesize = 36;
      show-recents = false;
      appswitcher-all-displays = true;
      # showhidden = true;
    };

    NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      ApplePressAndHoldEnabled = false;
      "com.apple.swipescrolldirection" = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    finder = {
      FXPreferredViewStyle = "Nlsv"; # List View
      AppleShowAllExtensions = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  # security.pam.enableSudoReattachAuth = true;
}
