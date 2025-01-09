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
    };
}
