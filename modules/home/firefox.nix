{
  lib,
  pkgs,
  config,
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

    # Enable GPU rendering.
    MOZ_WEBRENDER = "1";

    # Enable wayland support.
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Enable "Firefox".
  # See: https://www.mozilla.org/en-US/firefox/new
  programs.firefox = {
    enable = true;

    # Set the default user profile.
    profiles.${config.home.username} = {
      settings = {
        # Disables automatic updates.
        "app.update.auto" = false;
        # Disables automatic background updates.
        "app.update.background.enabled" = false;

        # Restore previous session on startup.
        "browser.startup.page" = 3;
        # Don't ask if this is the default browser.
        "browser.shell.checkDefaultBrowser" = false;
        # Don't switch to a new tab that was opened.
        "browser.tabs.loadBookmarksInBackground" = true;

        # Remove the "Account" button from the toolbar.
        "identity.fxaccounts.toolbar.enabled" = false;
        # Ensure bookmarks toolbar are only visible in a new tab.
        "browser.toolbars.bookmarks.visibility" = "newtab";
        # Disable "Web search" on the Firefox Home page.
        "browser.newtabpage.activity-stream.showSearch" = false;
        # Disable "Shortcuts" on the Firefox Home page.
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        # Enable "userChrome.css" customization support.
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Disable "Ask to save passwords".
        "signon.rememberSignons" = false;
        # Disable "Save and fill addresses".
        "extensions.formautofill.addresses.enabled" = false;
        # Disable "Save and fill payment methods".
        "extensions.formautofill.creditCards.enabled" = false;

        # Disable "Recommend extensions as you browse".
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        # Disable "Recommend features as you browse".
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        # Disable Pocket integration.
        "extensions.pocket.enabled" = false;

        # Disables the master switch for all data reporting.
        "datareporting.policy.dataSubmissionEnabled" = false;
        # Disables the submission of Firefox Health Reports.
        "datareporting.healthreport.uploadEnabled" = false;
        # Disables all telemetry and data collection features.
        "toolkit.telemetry.enabled" = false;
        # Disables the unified telemetry pipeline.
        "toolkit.telemetry.unified" = false;
        # Prevents telemetry data from being sent.
        "toolkit.telemetry.server" = "data:,";
        # Disables telemetry pings related to browser health.
        "toolkit.telemetry.bhrPing.enabled" = false;
        # Disables the archiving of old telemetry pings.
        "toolkit.telemetry.archive.enabled" = false;
        # Disables the telemetry ping sent after an update.
        "toolkit.telemetry.updatePing.enabled" = false;
        # Disables the telemetry ping sent from a new profile.
        "toolkit.telemetry.newProfilePing.enabled" = false;
        # Disables the telemetry ping sent on the first shutdown of a session.
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        # Disables the telemetry ping sender for shutdown events.
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        # Disables participation in Firefox "Studies".
        "app.shield.optoutstudies.enabled" = false;

        # Sets the master privacy preset to "Strict".
        "browser.contentblocking.category" = "strict";
        # Enables Total Cookie Protection by partitioning network state.
        "privacy.partition.network_state" = true;
        # Enables the primary Enhanced Tracking Protection feature.
        "privacy.trackingprotection.enabled" = true;
        # Enables protection against cryptomining scripts.
        "privacy.trackingprotection.cryptomining.enabled" = true;
        # Enables protection against email tracking pixels.
        "privacy.trackingprotection.emailtracking.enabled" = true;
        # Enables protection against fingerprinting scripts.
        "privacy.trackingprotection.fingerprinting.enabled" = true;
      };

      # Install browser extensions.
      extensions.packages = builtins.attrValues {
        inherit (pkgs.nur.repos.rycee.firefox-addons)
          ublock-origin
          ;
      };

      # Set custom "userChrome.css" styles.
      userChrome = ''
        :root {
          /* Rounded corners */
          --tab-border-radius: 8px !important;
          --toolbarbutton-border-radius: 8px !important;
        }

        /* Remove default shadows from tab bar */
        #tabbrowser-tabs,
        .tab-background {
          box-shadow: none !important;
        }

        /* Remove icons from the URL bar */
        #alltabs-button,
        #identity-icon-box,
        #picture-in-picture-button,
        #reader-mode-button,
        #tracking-protection-icon-container {
          display: none !important;
        }

        /* Remove "This time search with..." suggestions */
        #urlbar .search-one-offs {
          display: none !important;
        }

        /* Round the URL bar */
        #urlbar,
        #urlbar-background {
          border-radius: 8px !important;
        }

        /* Remove fullscreen warning border */
        #fullscreen-warning {
          border: none !important;
          background: -moz-Dialog !important;
        }

        /* Tab layout tweaks */
        .tabbrowser-tab {
          padding-top: 2px !important;
          padding-bottom: 2px !important;
        }

        /* Tab close button visibility and transitions */
        .tabbrowser-tab:not(:hover) .tab-close-button {
          opacity: 0% !important;
          transition: 0.3s !important;
        }

        .tab-close-button[selected]:not(:hover) {
          opacity: 45% !important;
          transition: 0.3s !important;
        }

        .tabbrowser-tab:hover .tab-close-button,
        .tab-close-button:hover,
        .tab-close-button[selected]:hover {
          opacity: 100% !important;
          background: none !important;
          cursor: pointer;
          transition: 0.3s !important;
        }

        /* Remove border around navigation toolbox */
        #navigator-toolbox {
          border: none !important;
        }

        /* Add spacer width when in fullscreen or without custom title bar */
        :root[inFullscreen] .titlebar-spacer {
          display: block !important;
          width: 8px !important;
        }

        /* Remove the extensions and import button */
        #unified-extensions-button,
        #import-button {
          display: none !important;
        }
      '';
    };
  };
}
