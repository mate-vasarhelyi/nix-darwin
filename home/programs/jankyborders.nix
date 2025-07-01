{ pkgs, ... }: {
  home.packages = with pkgs; [
    jankyborders
  ];

  # Launchd user service for macOS
  launchd.agents.borders = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.jankyborders}/bin/borders"
        "active_color=0xffe1e3e4"
        "inactive_color=0xff494d64"
        "width=5.0"
      ];
      Label = "org.nixos.borders";
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
} 