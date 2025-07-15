{ pkgs, ... }: {
  imports = [
    ./system.nix
  ];

  networking.hostName = "mates-macbook";
  networking.computerName = "Mate's MacBook";
  networking.localHostName = "mates-macbook";

  # Enable Fish shell system-wide
  programs.fish.enable = true;

  # Set primary user for system defaults
  system.primaryUser = "mate";

  users.users.mate = {
    name = "mate";
    home = "/Users/mate";
    shell = pkgs.fish;
    createHome = true;
    description = "mate";
  };

  # Font configuration for better icon support
  fonts = {
    packages = with pkgs; [
      # Nerd Fonts for sketchybar icons
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.sauce-code-pro
      # Additional fonts that might be needed
      nerd-fonts.meslo-lg
      nerd-fonts.ubuntu
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    nano
    tailscale
    # Add Nerd Fonts for sketchybar icons
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
  ];

  # Homebrew configuration
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";  # Removes all unmanaged formulae and casks
    };

    # Homebrew formulae
    brews = [];
    
    # Homebrew casks (GUI applications)
    casks = [
      # Development
      "cursor"
      "ghostty"
      "pgadmin4"
      "postman"
      "drawio"
      "figma"
      "slack"
      "microsoft-teams"
      "microsoft-outlook"
      "miro"
      "joplin"
      "claude"
      
      # Browsers
      "zen"
      
      # Communication
      "beeper"
      
      # Productivity
      "raycast"
      "onlyoffice"
      
      # File management
      "commander-one"
      "grandperspective"
      
      # System tools
      "karabiner-elements"
      
      # Gaming
      "steam"
      
      # Media
      "vlc"
      "spotify"
      "gimp"
      "jellyfin-media-player"
      "transmission"
      "balenaetcher"

      # Fonts
      "sf-symbols"
      "font-sketchybar-app-font"
    ];
  };

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";

  # System activation script to change user shell
  system.activationScripts.setUserShell.text = ''
    echo "Setting user shell to fish..."
    if [ "$(/usr/bin/dscl . -read /Users/mate UserShell 2>/dev/null | awk '{print $2}')" != "${pkgs.fish}/bin/fish" ]; then
      /usr/bin/dscl . -create /Users/mate UserShell ${pkgs.fish}/bin/fish
      echo "User shell changed to fish"
    else
      echo "User shell already set to fish"
    fi
  '';

  # Font cache refresh
  system.activationScripts.refreshFontCache.text = ''
    echo "Refreshing font cache..."
    /System/Library/Frameworks/ApplicationServices.framework/Frameworks/ATS.framework/Support/atsutil server -ping
    /System/Library/Frameworks/ApplicationServices.framework/Frameworks/ATS.framework/Support/atsutil databases -remove
    /System/Library/Frameworks/ApplicationServices.framework/Frameworks/ATS.framework/Support/atsutil server -shutdown
    /System/Library/Frameworks/ApplicationServices.framework/Frameworks/ATS.framework/Support/atsutil server -ping
    echo "Font cache refreshed"
  '';
}