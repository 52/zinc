{
  lib,
  config,
  osConfig,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  inherit (osConfig) wayland;
  cfg = config.env;
in
{
  options.env = mkOption {
    type =
      with types;
      attrsOf (oneOf [
        str
        path
        int
        float
      ]);
    description = "Set of environment variables";
    default = { };
  };

  config = mkIf (cfg != { }) (
    lib.mkMerge [
      # Mirror variables to 'home.sessionVariables'.
      ({ home.sessionVariables = cfg; })

      # Create 'uwsm/env' when wayland is enabled.
      (mkIf wayland.enable {
        xdg.configFile."uwsm/env".text = lib.concatStrings (
          lib.mapAttrsToList (name: value: ''
            export ${name}="${toString value}"
          '') cfg
        );
      })
    ]
  );
}
