{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.locale;
in
{
  options.locale = {
    default = mkOption {
      type = types.str;
      description = "System-wide default locale";
      default = "en_US.UTF-8";
    };

    supported = mkOption {
      type = types.listOf types.str;
      description = "List of supported locales";
      default = [
        "en_US.UTF-8"
        "de_DE.UTF-8"
      ];
    };

    categories = mkOption {
      type = types.listOf types.str;
      description = "List of locale categories";
      default = [
        "LC_ADDRESS"
        "LC_IDENTIFICATION"
        "LC_MEASUREMENT"
        "LC_MONETARY"
        "LC_NAME"
        "LC_NUMERIC"
        "LC_PAPER"
        "LC_TELEPHONE"
        "LC_TIME"
      ];
    };

    timeZone = mkOption {
      type = types.str;
      description = "System time zone";
      default = "Europe/Berlin";
    };
  };

  config = {
    i18n = {
      # Set the system-wide locale.
      defaultLocale = cfg.default;

      # Set the supported locales.
      supportedLocales = map (locale: "${locale}/UTF-8") cfg.supported;

      # Set the specific locale categories.
      extraLocaleSettings = builtins.listToAttrs (
        map (name: {
          inherit name;
          value = cfg.default;
        }) cfg.categories
      );
    };

    # Set the system time zone (local).
    time.timeZone = cfg.timeZone;
  };
}
