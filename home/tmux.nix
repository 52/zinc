{ pkgs, config, ... }:
let
  shell = config.home.sessionVariables.SHELL;
in
{
  programs = {
    tmux = {
      enable = true;
      shell = "${pkgs.${shell}}/bin/${shell}";
      historyLimit = 10000;
      extraConfig = ''
        set-option -sa terminal-features ',xterm-256color:RGB'
      '';
    };
  };
}
