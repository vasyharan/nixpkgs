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
      orientation = "left";
      tilesize = 36;
      show-recents = false;
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

  security.pam.enableSudoTouchIdAuth = true;
  # security.pam.enableSudoReattachAuth = true;
}
