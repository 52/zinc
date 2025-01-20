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
    emacs = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config =
    let
      inherit (config) emacs;
    in
    mkIf emacs.enable {
      xdg = {
        configFile = {
          "emacs" = {
            source = ../local/emacs;
            recursive = true;
          };
        };
      };
      programs = {
        emacs = {
          enable = true;
          package = pkgs.emacs30-pgtk.pkgs.withPackages (
            epkgs: with epkgs; [
              evil
            ]
          );
        };
      };
    };
}
