{ ... }:
{
  # enable tmux, see: https://github.com/tmux/tmux/wiki/
  programs.tmux = {
    enable = true;

    extraConfig = ''
      set -ga terminal-overrides ",*256col*:Tc:RGB"
      set -g default-terminal "xterm-256color"
      set -g history-limit 50000

      # fix: <esc> delay in vim
      set -sg escape-time 0

      # enable mouse scroll
      set -g mouse on
    '';
  };
}
