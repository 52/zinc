{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    tmux = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config =
    let
      inherit (config) tmux env;
    in
    mkIf tmux.enable {
      programs = {
        tmux = {
          enable = true;
          shell = "${pkgs.${env.SHELL}}/bin/${env.SHELL}";
          extraConfig = ''
            set -ga terminal-overrides ",*256col*:Tc:RGB"
            set -g default-terminal "xterm-256color"
            set -g history-limit 50000
            set -sg escape-time 0
          '';
        };
      };
    };
}
