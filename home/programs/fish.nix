{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    
    # Shell aliases
    shellAliases = {
      # Better defaults
      ls = "exa --icons";
      ll = "exa -l --icons";
      la = "exa -la --icons";
      tree = "exa --tree --icons";
      
      # Git shortcuts (oh-my-zsh inspired)
      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit -v";
      gca = "git commit -v -a";
      gcam = "git commit -a -m";
      gcb = "git checkout -b";
      gcm = "git checkout main";
      gcmsg = "git commit -m";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gf = "git fetch";
      gfa = "git fetch --all --prune";
      gfo = "git fetch origin";
      gl = "git pull";
      gm = "git merge";
      gmom = "git merge origin/main";
      gp = "git push";
      gpd = "git push --dry-run";
      gpf = "git push --force-with-lease";
      gpsup = "git push --set-upstream origin $(git_current_branch)";
      gpu = "git push upstream";
      grb = "git rebase";
      grba = "git rebase --abort";
      grbc = "git rebase --continue";
      gss = "git status -s";
      gst = "git status";
      gsta = "git stash push";
      gstaa = "git stash apply";

      # Kubernetes shortcuts (oh-my-zsh inspired)
      k = "kubectl";
      kg = "kubectl get";
      kd = "kubectl describe";
      
      # Context management
      kcuc = "kubectl config use-context";
      kccc = "kubectl config current-context";
      kcgc = "kubectl config get-contexts";
      kcn = "kubectl config set-context --current --namespace";
      
      # Apply and delete
      kaf = "kubectl apply -f";
      kdel = "kubectl delete";
      kdelf = "kubectl delete -f";
      
      # Pod management
      kgp = "kubectl get pods";
      kgpw = "kubectl get pods --watch";
      kgpwide = "kubectl get pods -o wide";
      kep = "kubectl edit pods";
      kdp = "kubectl describe pods";
      kdelp = "kubectl delete pod";
      keti = "kubectl exec -ti";
      
      # Service management
      kgs = "kubectl get svc";
      kes = "kubectl edit svc";
      kds = "kubectl describe svc";
      
      # Deployment management
      kgd = "kubectl get deployment";
      kgdw = "kubectl get deployment --watch";
      ked = "kubectl edit deployment";
      kdd = "kubectl describe deployment";
      ksd = "kubectl scale deployment";
      
      # Namespace management
      kgns = "kubectl get namespaces";
      
      # Logs and port forwarding
      kl = "kubectl logs";
      klf = "kubectl logs -f";
      kpf = "kubectl port-forward";
      
      # All resources
      kga = "kubectl get all";
      kgaa = "kubectl get all --all-namespaces";
      
      # System shortcuts
      reload = "source ~/.config/fish/config.fish";
      
      # Darwin rebuild shortcuts
      dr = "sudo darwin-rebuild switch --flake ~/nix-darwin#mates-macbook";
      dru = "cd ~/nix-darwin && nix flake update && sudo darwin-rebuild switch --flake ~/nix-darwin#mates-macbook";
      
      code = "cursor";
      
      mr = "mise run";
      mw = "mise watch";

      export-all = "export-cursor-extensions; export-cursor-settings; export-zen-prefs; export-zen-shortcuts";

      import-all = "install-cursor-extensions; import-zen-prefs; import-zen-shortcuts";
    };

    # Shell abbreviations (expand when you press space)
    shellAbbrs = {
      # Docker
      d = "docker";
      dc = "docker-compose";
      dcu = "docker-compose up";
      dcd = "docker-compose down";
      
      # Common directories
      dl = "cd ~/Downloads";
      dt = "cd ~/Desktop";
      docs = "cd ~/Documents";
      config = "cd ~/nix-darwin";
    };

    # Fish shell configuration
    interactiveShellInit = ''
      set -g fish_greeting
      
      set -gx EDITOR "cursor --wait"
      set -gx VISUAL "cursor --wait"
      set -gx GOPRIVATE "github.com/quantum-wealth/*,github.com/techtonic-org/*"

      fish_add_path $HOME/.local/bin
      fish_add_path (go env GOPATH)/bin
      
      set -g fish_history_max 10000
      
      set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
      set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'
      
      zoxide init fish | source
      
      direnv hook fish | source

      mise activate fish | source
    '';

    # Fish plugins
    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "v10.3";
          sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }
    ];
  };
}