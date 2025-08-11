{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
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

    overrides = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = { };
      description = ''
        Profiles mapped to their target device identifiers.

        These profiles are loaded from "local/keyd" and applied
        to specific keyboard devices using "keyd".
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

    # Enable "keyd".
    # See: https://github.com/rvaiya/keyd
    services.keyd = mkIf (cfg.overrides != { }) {
      enable = true;

      keyboards = builtins.mapAttrs (name: ids: {
        inherit ids;
        extraConfig = builtins.readFile (lib.relativePath "local/keyd/${name}.conf");
      }) cfg.overrides;
    };

    # Set the keyboard layout for the console.
    console.keyMap = cfg.layout;
  };
}
