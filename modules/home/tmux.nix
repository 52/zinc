{ ... }:
{
  # Enable tmux, see: https://github.com/tmux/tmux/wiki/
  programs.tmux = {
    enable = true;

    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g default-terminal "tmux-256color"
      set -g history-limit 50000

      # Fix: <esc> delay in vim
      set -sg escape-time 0

      # Enable mouse scroll
      set -g mouse on
    '';
  };
}
