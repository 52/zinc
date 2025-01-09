{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    system = {
      locale = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        defaultLocale = mkOption {
          type = types.str;
          default = "en_US.UTF-8";
        };
        supportedLocales = mkOption {
          type = types.listOf types.str;
          default = [
            "en_US.UTF-8"
            "de_DE.UTF-8"
          ];
        };
        localeCategories = mkOption {
          type = types.listOf types.str;
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
      };
    };
  };
  config =
    let
      inherit (builtins) listToAttrs;
      inherit (config) system;
      inherit (system) locale;
    in
    mkIf locale.enable {
      i18n =
        let
          inherit (locale) defaultLocale supportedLocales localeCategories;
        in
        {
          inherit defaultLocale;
          supportedLocales = map (x: "${x}/UTF-8") supportedLocales;
          extraLocaleSettings = builtins.listToAttrs (
            map (name: {
              inherit name;
              value = defaultLocale;
            }) localeCategories
          );
        };
    };
}
