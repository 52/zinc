{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.keyboard;
in
{
  options.keyboard = {
    layout = mkOption {
      type = types.str;
      default = "de";
      description = ''
        The keyboard layout to use.

        This sets the system-wide keyboard layout for
        both console and graphical environments.
      '';
    };

    variant = mkOption {
      type = types.str;
      default = "mac_nodeadkeys";
      description = ''
        The keyboard variant to use.

        This sets the system-wide keyboard variant with
        specific mappings and behaviours.
      '';
    };
  };

  config = {
    # Install system-wide dependencies.
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        keyd
        ;
    };

    # Set the keyboard layout for the console.
    console.keyMap = cfg.layout;
  };
}
