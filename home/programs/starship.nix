{ ... }: {
  programs.starship = {
    enable = true;
    
    settings = {
      # General settings
      add_newline = true;
      command_timeout = 1000;
      
      # Format
      format = "$all$character";
      
      # Character
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      
      # Directory
      directory = {
        truncation_length = 3;
        fish_style_pwd_dir_length = 1;
        style = "bold cyan";
      };
      
      # Git
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        symbol = " ";
        style = "bold purple";
      };
      
      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        style = "bold red";
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        up_to_date = "";
        untracked = "?\${count}";
        stashed = "$";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "✘\${count}";
      };
      
      # Languages
      nodejs = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold green";
      };
      
      python = {
        format = "[\${symbol}\${pyenv_prefix}(\${version} )(\\($virtualenv\\) )]($style)";
        symbol = " ";
        style = "bold yellow";
      };
      
      rust = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold red";
      };
      
      golang = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold cyan";
      };
      
      # Docker
      docker_context = {
        format = "[$symbol$context]($style) ";
        symbol = " ";
        style = "blue bold";
      };
      
      # Time
      time = {
        disabled = false;
        format = "[$time]($style) ";
        style = "bold white";
        time_format = "%T";
      };
      
      # Battery
      battery = {
        full_symbol = " ";
        charging_symbol = " ";
        discharging_symbol = " ";
        unknown_symbol = " ";
        empty_symbol = " ";
        
        display = [
          {
            threshold = 15;
            style = "bold red";
          }
          {
            threshold = 50;
            style = "bold yellow";
          }
          {
            threshold = 80;
            style = "bold green";
          }
        ];
      };
      
      # Command duration
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "bold yellow";
        min_time = 2000;
      };
    };
  };
}