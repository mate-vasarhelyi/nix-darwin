{ pkgs, ... }: {
  programs.sketchybar = {
    enable = true;
    # package = pkgs.sketchybar;  # Uses nixpkgs.sketchybar by default
    
    # ===== CONFIGURATION TYPE =====
    configType = "bash";  # "bash" or "lua"
    
    # ===== SERVICE CONFIGURATION =====
    service = {
      enable = true;  # Enable launchd service (default: true)
      errorLogFile = null;  # Uses default: ~/Library/Logs/sketchybar/sketchybar.err.log
      outLogFile = null;    # Uses default: ~/Library/Logs/sketchybar/sketchybar.out.log
    };
    
    # ===== EXTRA PACKAGES =====
    extraPackages = with pkgs; [
      # Add packages you need in PATH for sketchybar scripts
      jq
      curl
      bc
    ];
    
    includeSystemPath = true;  # Include system PATH (/usr/bin, etc.)
    
    config = {
      source = ./config;
      recursive = true;  # Copy entire directory structure
    };
  };
} 