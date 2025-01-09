{ lib, config, ... }:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    env = mkOption {
      type =
        with types;
        attrsOf (oneOf [
          str
          path
          int
          float
        ]);
      default = { };
      apply =
        env:
        {
          # firefox
          MOZ_WEBRENDER = "1";
          MOZ_ENABLE_WAYLAND = "1";
          # chromium
          NIXOS_OZONE_WL = "1";
        }
        // env;
    };
  };
  config =
    let
      inherit (lib) concatStrings mapAttrsToList;
      inherit (config) env;
    in
    mkIf (env != { }) {
      xdg = {
        configFile = {
          "uwsm/env" = {
            text = concatStrings (
              mapAttrsToList (name: value: ''
                export ${name}="${toString value}"
              '') env
            );
          };
        };
      };
    };
}
