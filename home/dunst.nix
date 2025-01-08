{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (builtins) attrValues;
  inherit (config) hyprland;
  inherit (lib) mkIf;
in
mkIf hyprland.enable {
  home = {
    packages = attrValues {
      inherit (pkgs) libnotify;
    };
  };
  services = {
    dunst = {
      enable = true;
      settings = {
        global = {
          width = 400;
          height = 350;
          font = "monospace 14";
          word_wrap = "no";
          allow_markup = "yes";
          ignore_newline = "no";
        };
        urgency_low = {
          timeout = 10;
        };
        urgency_normal = {
          timeout = 10;
        };
        urgency_critical = {
          timeout = 0;
        };
      };
    };
  };
}
