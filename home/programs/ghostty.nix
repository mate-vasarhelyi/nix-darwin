{ ... }: {
  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      shell-integration-features = "ssh-terminfo,ssh-env";
      theme = "Dark Pastel";
      background-opacity = 0.9;
    };
  };
}
