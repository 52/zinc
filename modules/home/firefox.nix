{
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (osConfig) wayland;
in
mkIf wayland.enable {
  env = {
    # Set the default browser.
    BROWSER = "firefox";

    # Enable GPU rendering (firefox).
    MOZ_WEBRENDER = "1";

    # Enable wayland support (firefox).
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Enable firefox, see: https://www.mozilla.org/en-US/firefox/new/
  programs.firefox = {
    enable = true;

    policies = {
      # Disable automatic updates.
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;

      # Allow native features.
      DisableFirefoxAccounts = false;
      DisableBuiltinPDFViewer = false;

      # Disable annoying features.
      DisablePocket = true;
      DisableTelemetry = true;
      OfferToSaveLogins = false;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;

      # Enable tracking protection.
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };

      # Define general preferences.
      Preferences = {
        "browser.startup.page" = 3;
      };

      # Install marketplace extensions.
      ExtensionUpdate = false;
      ExtensionSettings =
        let
          mkExtension = abbrvId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${abbrvId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
        builtins.listToAttrs [
          (mkExtension "ublock-origin" "uBlock0@raymondhill.net")
        ];
    };
  };
}
