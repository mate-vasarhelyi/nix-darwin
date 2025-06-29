{ ... }: 
let
  cursorSettings = import ./settings.nix;
in
{
  # Use activation script to copy settings file instead of symlinking
  home.activation.cursorSettings = ''
    $DRY_RUN_CMD mkdir -p "$HOME/Library/Application Support/Cursor/User"
    
    # Remove existing file/symlink first, then create new writable file
    $DRY_RUN_CMD rm -f "$HOME/Library/Application Support/Cursor/User/settings.json"
    $DRY_RUN_CMD cat > "$HOME/Library/Application Support/Cursor/User/settings.json" << 'EOF'
    ${builtins.toJSON cursorSettings}
    EOF
  '';
  
  # Keep the utility scripts
  home.file = {
    ".local/bin/export-cursor-settings" = {
      source = ./export-settings.sh;
      executable = true;
    };
    ".local/bin/export-cursor-extensions" = {
      source = ./export-extensions.sh;
      executable = true;
    };
    ".local/bin/install-cursor-extensions" = {
      source = ./install-extensions.sh;
      executable = true;
    };
  };
} 