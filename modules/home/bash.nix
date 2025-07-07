{
  config,
  ...
}:
{
  # set default shell
  home.sessionVariables.SHELL = "bash";

  # enable bash, see: https://www.gnu.org/software/bash/
  programs.bash = {
    enable = true;

    # limit the number of lines (memory)
    historySize = 500000;

    # limit the number of lines (flushed)
    historyFileSize = 100000;

    # remove the `.bash_history` file from $HOME
    historyFile = "${config.xdg.dataHome}/bash/bash_history";

    historyControl = [
      # ignore duplicate entries
      "ignoredups"

      # remove duplicate entries
      "erasedups"
    ];

    shellOptions = [
      # enable recursive globbing
      "globstar 2> /dev/null"

      # enable case-insensitive globbing
      "nocaseglob;"

      # append to history file
      "histappend"

      # update window frequently
      "checkwinsize"

      # save multi-line commands as one entry
      "cmdhist"

      # prepend 'cd' to directory names
      "autocd 2> /dev/null"

      # correct spelling errors during 'cd'
      "cdspell 2> /dev/null"

      # correct spelling errors during tab-completion
      "dirspell 2> /dev/null"
    ];

    shellAliases = {
      ".." = "cd ..";

      # disk
      df = "df -h";
      du = "du -h -c";

      # list
      ls = "ls -lF -G --group-directories-first --color=auto";
      la = "ls -lAF -G --group-directories-first --color=auto";

      # git
      g = "git";
      ga = "git add";
      gp = "git push";
      gd = "git diff";
      gc = "git commit";
      gs = "git status";
      gb = "git branch";
      gl = "git log --decorate --oneline --graph";

      # nix
      n = "nix";
      nd = "nix develop";

      # tmux
      t = "tmux";
      tl = "tmux ls";
      td = "tmux detach";
      ta = "tmux attach -t";
    };

    # enable 'bash-sensible', see: https://github.com/mrzool/bash-sensible/
    initExtra = ''
      # enable case-insensitve completion
      bind "set completion-ignore-case on"

      # treat hyphens and underscores equally
      bind "set completion-map-case on"

      # display all matches immediatly
      bind "set show-all-if-ambiguous on"

      # append slash to symlinked directories
      bind "set mark-symlinked-directories on"

      # enable incremental history search
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'
      bind '"\e[C": forward-char'
      bind '"\e[D": backward-char'
    '';
  };
}
