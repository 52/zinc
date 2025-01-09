{ lib, config, ... }:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    system = {
      firefox = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
      };
    };
  };
  config =
    let
      inherit (config) system;
      inherit (system) firefox;
    in
    mkIf firefox.enable {
      programs = {
        firefox = {
          enable = true;
          # see: https://mozilla.github.io/policy-templates or `about:policies#documentation`
          policies = {
            AppAutoUpdate = false;
            BackgroundAppUpdate = false;
            # privacy
            DisablePocket = true;
            DisableTelemetry = true;
            OfferToSaveLogins = false;
            DisableFirefoxStudies = true;
            DisableFirefoxAccounts = false;
            DontCheckDefaultBrowser = true;
            DisableBuiltinPDFViewer = false;
            # tracking
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
              EmailTracking = true;
            };
            # settings
            Preferences = {
              "browser.startup.page" = 3;
            };
            # extensions
            ExtensionUpdate = false;
            ExtensionSettings =
              let
                inherit (builtins) listToAttrs;
                mkExtension = abbrvId: uuid: {
                  name = uuid;
                  value = {
                    install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${abbrvId}/latest.xpi";
                    installation_mode = "normal_installed";
                  };
                };
              in
              listToAttrs [
                (mkExtension "ublock-origin" "uBlock0@raymondhill.net")
              ];
          };
        };
      };
    };
}
