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
      default = false;
      description = ''
        Whether to enable the "wayland" module.

        This enables the Wayland Display Protocol with a compositor
        managed by the "UWSM" (Universal Wayland Session Manager).
      '';
    };
  };

  config = mkIf cfg.enable {
    # Install system-wide dependencies.
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        wl-clipboard
        slurp
        grim
        ;
    };

    # Enable "Sway".
    # See: https://swaywm.org
    programs.sway.enable = true;

    # Enable "UWSM" (Universal Wayland Session Manager).
    # See: https://github.com/vladimir-csp/uwsm
    programs.uwsm = {
      enable = true;

      # Define the wayland compositors.
      waylandCompositors.sway = {
        prettyName = "Sway";
        comment = "Sway compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/sway";
      };
    };

    # Automatically start "UWSM" on login.
    programs.bash.loginShellInit = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        if uwsm check may-start; then
          exec uwsm start sway-uwsm.desktop
        fi
      fi
    '';

    # Configure "XDG Desktop Portal".
    # See: https://github.com/flatpak/xdg-desktop-portal
    xdg.portal = {
      enable = true;

      # Install the backends for "WLR" and "GTK".
      extraPortals = builtins.attrValues {
        inherit (pkgs)
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
          ;
      };
    };

    # Enable "Polkit".
    # See: https://wiki.archlinux.org/title/Polkit
    security.polkit.enable = true;

    # Manage the "video" group.
    users.groups.video = {
      members = builtins.attrNames (
        lib.filterAttrs (_: user: user.isNormalUser or false) config.users.users
      );
    };
  };
}
