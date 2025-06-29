{ ... }: {
  # System-wide macOS settings
  system.defaults = {
    # Dock settings
    dock = {
      autohide = true;
      autohide-delay = 1000.0;  # Effectively disables dock (1000 second delay = never shows)
      tilesize = 64;  # Your current setting
    };

    # Finder settings
    finder = {
      # Based on your current settings
      FXDefaultSearchScope = "SCcf"; # Search current folder by default - matches your setting
      FXPreferredViewStyle = "Nlsv"; # List view - matches your setting
      ShowExternalHardDrivesOnDesktop = true;  # Your current setting
      ShowHardDrivesOnDesktop = false;  # Your current setting
      ShowRemovableMediaOnDesktop = true;  # Your current setting
      # Note: Many default settings not explicitly set in your config
    };

    # Login window settings
    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };


    # Trackpad settings - using only well-supported options
    trackpad = {
      Clicking = true;  # Tap to click
      TrackpadRightClick = true;  # Right click
      TrackpadThreeFingerDrag = false;  # Three finger drag
    };

    # Global system settings
    NSGlobalDomain = {
      # Based on your current NSGlobalDomain settings
      AppleInterfaceStyle = "Dark";  # Your current setting
      InitialKeyRepeat = 15;  # Your current setting
      KeyRepeat = 2;  # Your current setting
      NSAutomaticCapitalizationEnabled = false;  # Your current setting (0)
      NSAutomaticPeriodSubstitutionEnabled = true;  # Your current setting (1)
      NSAutomaticSpellingCorrectionEnabled = false;  # Your current setting (0)
      # Note: Many settings not explicitly found in your current config
      # Keeping only the ones that match your actual system
    };

    # Screen capture settings
    screencapture = {
      # Your current screencapture defaults to style=selection
      type = "png";  # Keeping default png format
      # Note: location not explicitly set in your config, using default
    };

    # Activity Monitor settings
    ActivityMonitor = {
      # Using valid ShowCategory value (100-107 are valid)
      ShowCategory = 100;  # All Processes
      OpenMainWindow = true;  # Your current setting
    };
  };

  # Keyboard settings
  system.keyboard = {
    enableKeyMapping = true;
    # Note: Caps Lock remapping not found in your current config
    # You might want to set this if you prefer it
    # remapCapsLockToEscape = true;
  };

  # Time zone
  time.timeZone = "Europe/Budapest";

  # nix-daemon is now managed automatically by nix-darwin

  # Enable Tailscale
  services.tailscale.enable = true;
}