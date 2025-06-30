{ pkgs, ... }: {
  imports = [
    ./programs/aerospace.nix
    ./programs/sketchybar
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/starship.nix
    ./programs/direnv.nix
    ./programs/cursor
    ./programs/zen
  ];

  home.username = "mate";
  home.homeDirectory = "/Users/mate";

  home.stateVersion = "24.05";

  # Font configuration for better icon support
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    go
    mise
    zoxide
    fd
    eza
    kubelogin
    fluxcd
    postgresql_17_jit
    # Add fonts for better icon support
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.sauce-code-pro
    nixd
    gh
    fzf
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}