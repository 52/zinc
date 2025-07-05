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
      description = "Keyboard layout for all keyboards";
      default = "de";
    };

    variant = mkOption {
      type = types.str;
      description = "Keyboard variant for all keyboards";
      default = "mac_nodeadkeys";
    };

    remaps = mkOption {
      type = types.attrsOf (types.listOf types.str);
      description = "Keyd profiles mapped to device Ids";
      default = { };
    };
  };

  config = {
    # install dependencies (system-wide)
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        keyd
        ;
    };

    # apply keyboard remaps
    services.keyd = mkIf (cfg.remaps != { }) {
      enable = true;
      keyboards = builtins.mapAttrs (name: ids: {
        inherit ids;
        extraConfig = builtins.readFile (lib.relativePath "local/keyd/${name}.conf");
      }) cfg.remaps;
    };

    # set keyboard layout (tty)
    console.keyMap = cfg.layout;
  };
}
