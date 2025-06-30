{ ... }: {
  programs.git = {
    enable = true;
    userName = "Mate Vasarhelyi";
    userEmail = "mate.vasarhelyi@alpheya.com";
    
    extraConfig = {
      core = {
        editor = "cursor --wait";
        autocrlf = "input";
        ignorecase = false;
      };
      
      pull.rebase = true;
      push.default = "simple";
      init.defaultBranch = "main";
      
      # Better diffs
      diff = {
        tool = "vimdiff";
        colorMoved = "default";
      };
      
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
      };
      
      # URL shortcuts
      url = {
        "https://github.com/".insteadOf = "gh:";
        "ssh://git@github.com".pushInsteadOf = "https://github.com/";
        "ssh://git@github.com/".insteadOf = "https://github.com/";
      };
      
      # Colors
      color = {
        ui = "auto";
        branch = "auto";
        diff = "auto";
        status = "auto";
      };
    };
    
    # Global gitignore
    ignores = [
      # macOS
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon"
      "._*"
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
    ];
  };
}
