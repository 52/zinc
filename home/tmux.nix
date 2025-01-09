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
      inherit (config) tmux home;
      inherit (home) sessionVariables;
    in
    mkIf tmux.enable {
      programs = {
        tmux = {
          enable = true;
          shell = "${pkgs.${sessionVariables.SHELL}}/bin/${sessionVariables.SHELL}";
          historyLimit = 10000;
          extraConfig = ''
            set-option -sa terminal-features ',xterm-256color:RGB'
          '';
        };
      };
    };
}
