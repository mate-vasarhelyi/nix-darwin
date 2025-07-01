{ ... }: {
  # OrbStack startup configuration
  launchd.agents.orbstack = {
    enable = true;
    config = {
      ProgramArguments = [
        "/Applications/OrbStack.app/Contents/MacOS/OrbStack"
      ];
      Label = "org.nixos.orbstack";
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;  # Don't restart if it exits successfully
      };
      # Hide the dock icon on startup
      ProcessType = "Background";
    };
  };
} 