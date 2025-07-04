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
      description = "Whether to enable the docker module";
      default = false;
    };

    members = mkOption {
      type = types.listOf types.str;
      description = "<todo>";
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    # install dependencies (system-wide)
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        kubectl
        ;
    };

    # enable docker, see: https://docs.docker.com/
    virtualisation.docker = {
      enable = true;

      # enable periodical pruning of docker resources
      autoPrune.enable = true;
    };

    # manage the 'docker' group
    users.groups.docker = {
      inherit (cfg) members;
    };
  };
}
