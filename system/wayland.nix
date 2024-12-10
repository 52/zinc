{
  lib,
  pkgs,
  config,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [
      wl-clipboard
    ];
    sessionVariables =
      {
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_CURRENT_DESKTOP = "Hyprland";
      }
      // lib.optionalAttrs config.programs.firefox.enable {
        MOZ_ENABLE_WAYLAND = "1";
        MOZ_WEBRENDER = "1";
      };
  };
  programs = {
    hyprland = {
      enable = true;
    };
  };
}
