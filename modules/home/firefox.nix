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
  # set environment variables (user)
  home.sessionVariables = {
    # set default browser
    BROWSER = "firefox";

    # enable GPU rendering (firefox)
    MOZ_WEBRENDER = "1";

    # enable wayland support (firefox)
    MOZ_ENABLE_WAYLAND = "1";
  };

  # enable firefox, see: https://www.mozilla.org/en-US/firefox/new/
  programs.firefox = {
    enable = true;

    # set policies
    policies = {
      # disable updates
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;

      # allow features
      DisableFirefoxAccounts = false;
      DisableBuiltinPDFViewer = false;

      # disable features
      DisablePocket = true;
      DisableTelemetry = true;
      OfferToSaveLogins = false;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;

      # enable tracking protection
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };

      # define preferences
      Preferences = {
        "browser.startup.page" = 3;
      };

      # install extensions
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
