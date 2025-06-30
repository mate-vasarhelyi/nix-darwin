{ ... }: 
{
  # Install utility scripts for managing Zen Browser configuration
  # Note: Zen Browser must be run at least once before importing configuration
  # to ensure the profile directory structure exists.
  home.file = {
    ".local/bin/export-zen-shortcuts" = {
      source = ./export-shortcuts.sh;
      executable = true;
    };
    ".local/bin/export-zen-prefs" = {
      source = ./export-prefs.sh;
      executable = true;
    };
    ".local/bin/import-zen-shortcuts" = {
      source = ./import-shortcuts.sh;
      executable = true;
    };
    ".local/bin/import-zen-prefs" = {
      source = ./import-prefs.sh;
      executable = true;
    };
  };

  # Usage instructions:
  # 1. First, run Zen Browser at least once to create the profile structure
  # 2. Configure Zen Browser as desired (shortcuts, preferences, etc.)
  # 3. Export current settings: run 'export-zen-shortcuts' and 'export-zen-prefs'
  # 4. On a new system or after rebuilding: run 'import-zen-shortcuts' and 'import-zen-prefs'
  #
  # Unlike other browser configurations, Zen Browser settings are applied manually
  # because the browser needs to be run first to create the profile structure,
  # and automatic file overwrites during browser runtime can cause issues.
} 