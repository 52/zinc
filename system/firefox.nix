_: {
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
            extension = abbrvId: uuid: {
              name = uuid;
              value = {
                install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${abbrvId}/latest.xpi";
                installation_mode = "normal_installed";
              };
            };
          in
          builtins.listToAttrs [
            (extension "ublock-origin" "uBlock0@raymondhill.net")
          ];
      };
    };
  };
}
