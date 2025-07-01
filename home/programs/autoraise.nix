{ pkgs, ... }: {
  home.packages = with pkgs; [
    autoraise
  ];

  # Launchd user service for macOS
  launchd.agents.autoraise = {
    enable = true;
    config = {
      ProgramArguments = [ "${pkgs.autoraise}/bin/autoraise" "-delay" "1" "-warp" ];
      Label = "org.nixos.autoraise";
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "/tmp/autoraise.err";
      StandardOutPath = "/tmp/autoraise.out";
    };
  };
} 
  