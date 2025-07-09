{
  config,
  ...
}:
{
  # Set the default shell.
  env.SHELL = "bash";

  # Enable bash, see: https://www.gnu.org/software/bash/
  programs.bash = {
    enable = true;

    # Limit the number of lines (memory).
    historySize = 500000;

    # Limit the number of lines (flushed).
    historyFileSize = 100000;

    # Remove the '.bash_history' file from home.
    historyFile = "${config.xdg.dataHome}/bash/bash_history";

    historyControl = [
      # Ignore duplicate entries.
      "ignoredups"

      # Remove duplicate entries.
      "erasedups"
    ];

    shellOptions = [
      # Enable recursive globbing.
      "globstar 2> /dev/null"

      # Enable case-insensitive globbing.
      "nocaseglob;"

      # Append to history file.
      "histappend"

      # Update window more frequently.
      "checkwinsize"

      # Save multi-line commands as one entry.
      "cmdhist"

      # Prepend 'cd' to directory names.
      "autocd 2> /dev/null"

      # Correct spelling errors during 'cd'.
      "cdspell 2> /dev/null"

      # Correct spelling errors during completion.
      "dirspell 2> /dev/null"
    ];

    shellAliases = {
      ".." = "cd ..";

      # Disk
      df = "df -h";
      du = "du -h -c";

      # List
      ls = "ls -lF -G --group-directories-first --color=auto";
      la = "ls -lAF -G --group-directories-first --color=auto";

      # Git
      g = "git";
      ga = "git add";
      gp = "git push";
      gd = "git diff";
      gc = "git commit";
      gs = "git status";
      gb = "git branch";
      gl = "git log --decorate --oneline --graph";

      # Nix
      n = "nix";
      nd = "nix develop";

      # Vim
      v = "vim";
      vi = "vim";

      # Tmux
      t = "tmux";
      tl = "tmux ls";
      td = "tmux detach";
      ta = "tmux attach -t";
      tk = "tmux kill-session -t";
    };

    # Enable 'bash-sensible', see: https://github.com/mrzool/bash-sensible/
    initExtra = ''
      # Enable case-insensitve completion.
      bind "set completion-ignore-case on"

      # Treat hyphens and underscores equally.
      bind "set completion-map-case on"

      # Display all matches immediatly.
      bind "set show-all-if-ambiguous on"

      # Append slash to symlinked directories.
      bind "set mark-symlinked-directories on"

      # Move cursor to eol when cycling.
      bind "set history-preserve-point off"

      # Cycle through autocomplete.
      bind 'tab: menu-complete'
      bind '"\e[Z": menu-complete-backward'

      # Enable incremental history search.
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'
      bind '"\e[C": forward-char'
      bind '"\e[D": backward-char'
    '';
  };
}
