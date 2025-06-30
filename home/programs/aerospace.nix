{ ... }: {
  programs.aerospace = {
    enable = true;
    
    # Launchd service management (recommended)
    launchd = {
      enable = true;      # Let Home Manager manage the service
      keepAlive = true;   # Restart if it crashes
    };
    
    userSettings = {
      # ===== BASIC LAYOUT SETTINGS =====
      default-root-container-layout = "tiles";        # "tiles" or "accordion"
      default-root-container-orientation = "auto";    # "horizontal", "vertical", "auto"
      accordion-padding = 30;                          # Pixels between windows in accordion
      
      # ===== NORMALIZATION =====
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      
      # ===== STARTUP COMMANDS =====
      after-startup-command = [
        # Example commands - see https://nikitabobko.github.io/AeroSpace/commands
        "layout tiles"
        # "exec-and-forget open -n /System/Applications/Utilities/Terminal.app"
      ];
      
      # ===== KEYBOARD MAPPING =====
      key-mapping.preset = "qwerty";  # or "dvorak"
      
      # ===== WORKSPACE MONITORING =====
      workspace-to-monitor-force-assignment = {
        "1" = 1;                    # First monitor from left to right
        "2" = "main";               # Main monitor
        "3" = "secondary";          # Secondary monitor (non-main)
        # "4" = "built-in";           # Built-in display
        # "5" = "^built-in retina display$";  # Regex pattern
        # "6" = ["secondary" "dell"];         # Match first in list
      };
      
      # ===== EVENT CALLBACKS =====
      on-focus-changed = [
        "move-mouse window-lazy-center"
      ];
      
      on-focused-monitor-changed = [
        "move-mouse monitor-lazy-center"
      ];
      
      exec-on-workspace-change = [
        "/bin/bash" 
        "-c" 
        "/etc/profiles/per-user/mate/bin/sketchybar --trigger workspace_focus FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE PREV_FOCUSED=$AEROSPACE_PREV_WORKSPACE"
      ];
      
      # ===== WINDOW DETECTION RULES =====
      on-window-detected = [
        {
          "if" = {
            app-id = "com.apple.finder";                    # Optional: App bundle ID
            # workspace = "finder-workspace";               # Optional: Workspace name
            # window-title-regex-substring = "Downloads";   # Optional: Window title pattern
            # app-name-regex-substring = "Finder";          # Optional: App name pattern
            # during-aerospace-startup = false;             # Optional: Only during startup
          };
          check-further-callbacks = false;  # Stop processing other rules
          run = [
            "move-node-to-workspace 1"
            # "resize-node"
          ];
        }
        # Add more window detection rules here...
      ];
      
      # ===== GAPS - Fixed to leave space for sketchybar =====
      gaps = {
        outer.left = 8;
        outer.bottom = 8;
        outer.top = 46;
        outer.right = 8;
        # Add inner gaps between windows
        inner.horizontal = 8;
        inner.vertical = 8;
      };
      
      # ===== KEYBINDINGS =====
      mode.main.binding = {
        # Focus movement
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
        
        # Window movement
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";
        
        # Workspace switching
        alt-backtick = "workspace 0";
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        
        # Move to workspace
        alt-shift-backtick = "move-node-to-workspace 0";
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        
        # Layout toggles
        alt-shift-space = "layout floating tiling";
        alt-f = "fullscreen";
        
        # Resizing
        alt-shift-minus = "resize smart -50";
        alt-shift-equal = "resize smart +50";
      };
    };
  };
} 