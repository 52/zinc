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
      description = "Whether to enable the 'wayland' module";
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

    # enable sway, see: https://swaywm.org/
    programs.sway = {
      enable = true;
    };

    # enable uwsm, see: https://github.com/vladimir-csp/uwsm/
    programs.uwsm = {
      enable = true;

      # primary compositor (sway)
      waylandCompositors.sway = {
        prettyName = "Sway";
        comment = "Sway compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/sway";
      };
    };

    # automatically start uwsm on login
    programs.bash.loginShellInit = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        if uwsm check may-start; then
          exec uwsm start sway-uwsm.desktop
        fi
      fi
    '';

    # enable polkit, see: https://nixos.wiki/wiki/Sway/
    security.polkit.enable = true;

    # manage the 'video' group
    users.groups.video = {
      members = builtins.attrNames (lib.filterAttrs (_: u: u.isNormalUser or false) config.users.users);
    };
  };
}
