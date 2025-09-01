{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  inherit (osConfig) wayland;
in
{
  options.theme = {
    wallpaper = mkOption {
      type = types.path;
      default = lib.relativePath "local/137242.png";
      description = ''
        Path to the wallpaper file.

        This image is used as the desktop background across all outputs.
      '';
    };

    colors = {
      background = mkOption {
        type = types.str;
        default = "1c1c1c";
        description = ''
          Color for the primary background.

          This color is applied to backgrounds of elements.
        '';
      };

      foreground = mkOption {
        type = types.str;
        default = "dedede";
        description = ''
          Color for the primary foreground.

          This color is applied to primary text content.
        '';
      };

      border = mkOption {
        type = types.str;
        default = "303030";
        description = ''
          Color for unfocused window borders.

          This color is applied to borders and edges when not selected.
        '';
      };

      focus = mkOption {
        type = types.str;
        default = "6c6c6c";
        description = ''
          Color for focused window borders.

          This color is applied to borders and edges when selected.
        '';
      };

      dark = mkOption {
        type = types.str;
        default = "303030";
        description = ''
          Color for the secondary background.

          This color is applied to backgrounds of darkened elements.
        '';
      };

      hint = mkOption {
        type = types.str;
        default = "474747";
        description = ''
          Color for subtle elements and secondary foreground.

          This color is applied to secondary text content and sublte elements.
        '';
      };
    };
  };

  config = mkIf wayland.enable {
    # Set the default theme.
    env.GTK_THEME = "Adwaita-dark";

    # Configure "GTK".
    # See: https://gtk.org
    gtk = {
      enable = true;

      # Set the GTK theme.
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      # Set the icon theme.
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };

      # Prefer dark colorscheme for GTK3.
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };

      # Prefer dark colorscheme for GTK4.
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

    # Set the interface preferences for GNOME.
    dconf.settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };
}
