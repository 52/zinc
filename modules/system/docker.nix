{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.docker;
in
{
  options.docker = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable the 'docker' module";
      default = false;
    };

    members = mkOption {
      type = types.listOf types.str;
      description = "Users to add to the 'docker' group";
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    # Install system-wide dependencies.
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        kubectl
        ;
    };

    # Enable docker, see: https://docs.docker.com/
    virtualisation.docker = {
      enable = true;

      # Enable periodical pruning of resources.
      autoPrune.enable = true;
    };

    # Manage the 'docker' group.
    users.groups.docker = {
      inherit (cfg) members;
    };
  };
}
