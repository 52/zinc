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
  user = config.home.username;
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

  # Enable firefox, see: https://www.mozilla.org/en-US/firefox/new/
  programs.firefox = {
    enable = true;

    # Set the default user profile.
    profiles.${user} = {
      settings = {
        #
        # ---- Browser ----
        #
        # Restore previous session on startup.
        "browser.startup.page" = 3;
        # Don't ask if this is the default browser.
        "browser.shell.checkDefaultBrowser" = false;

        #
        # ---- Updates ----
        #
        # Disables automatic updates.
        "app.update.auto" = false;
        # Disables automatic background updates.
        "app.update.background.enabled" = false;

        #
        # ---- Layout ----
        #
        # Remove the "Account" button from the toolbar.
        "identity.fxaccounts.toolbar.enabled" = false;
        # Ensure the bookmarks toolbar is always visible.
        "browser.toolbars.bookmarks.visibility" = "always";
        # Disable "Web search" on the Firefox Home page.
        "browser.newtabpage.activity-stream.showSearch" = false;
        # Disable "Shortcuts" on the Firefox Home page.
        "browser.newtabpage.activity-stream.feeds.topsites" = false;

        #
        # ---- Passwords ----
        #
        # Disable "Ask to save passwords".
        "signon.rememberSignons" = false;
        # Disable "Save and fill addresses".
        "extensions.formautofill.addresses.enabled" = false;
        # Disable "Save and fill payment methods".
        "extensions.formautofill.creditCards.enabled" = false;

        #
        # ---- Features ----
        #
        # Disable "Recommend extensions as you browse".
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        # Disable "Recommend features as you browse".
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        # Disable Pocket integration.
        "extensions.pocket.enabled" = false;

        #
        # ---- Telemetry ----
        #
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

        #
        # ---- Privacy ----
        #
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

      # Set the browser extensions.
      extensions.packages = builtins.attrValues {
        inherit (pkgs.nur.repos.rycee.firefox-addons)
          ublock-origin
          ;
      };
    };
  };
}
