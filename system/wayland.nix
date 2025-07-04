{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.wayland;
in
{
  options.wayland = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable the wayland module";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # install dependencies (system-wide)
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        wl-clipboard
        ;
    };

    # manage the 'video' group
    users.groups.video = {
      members = builtins.attrNames (lib.filterAttrs (_: u: u.isNormalUser or false) config.users.users);
    };
  };
}
