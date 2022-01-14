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
      # showhidden = true;
    };

    NSGlobalDomain = {
      InitialKeyRepeat = 10;
      KeyRepeat = 1;
      "com.apple.swipescrolldirection" = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
  };
}
