{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    system = {
      keyboard = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        layout = mkOption {
          type = types.str;
          default = "de";
        };
        variant = mkOption {
          type = types.str;
          default = "mac,nodeadkeys";
        };
        enableOSXRemaps = mkOption {
          type = types.bool;
          default = true;
        };
      };
    };
  };
  config =
    let
      inherit (config) system;
      inherit (system) keyboard;
    in
    mkIf keyboard.enable {
      console = {
        keyMap = keyboard.layout;
      };
      services = mkIf keyboard.enableOSXRemaps {
        keyd = {
          enable = true;
          keyboards = {
            default = {
              ids = [ "*" ];
              settings = {
                main = {
                  leftalt = "rightalt";
                };
              };
            };
          };
        };
      };
    };
}
