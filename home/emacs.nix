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
      inherit (config) emacs xdg;
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
          package = pkgs.emacsWithPackagesFromUsePackage {
            config = "${xdg.configHome}/emacs/init.el";
            package = pkgs.emacs30-pgtk;
          };
        };
      };
    };
}
