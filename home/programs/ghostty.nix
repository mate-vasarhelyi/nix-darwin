{ ... }: {
  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      shell-integration-features = "ssh-terminfo,ssh-env";
    };
  };
}
