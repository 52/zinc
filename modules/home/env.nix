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
    default = { };
    description = ''
      Set of environment variables.

      These variables will be available in the user's shell
      sesion and exported to "uwsm" when Wayland is enabled.
    '';
  };

  config = mkIf (cfg != { }) (
    lib.mkMerge [
      # Set the session variables.
      { home.sessionVariables = cfg; }

      # Create the "uwsm/env" file when wayland is enabled.
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
