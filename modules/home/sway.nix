{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (osConfig) wayland keyboard;
  env = config.env;

  # List of startup commands and programs.
  autostart = lib.concatStringsSep " && sleep 1 && " [
    "swayrun -w 1 ${env.BROWSER or "firefox"}"
    "swayrun -w 1 ${env.TERMINAL or "foot"}"
    "swayrun -w 2 vesktop"
    "swayrun -w 3 spotify"
  ];
in
mkIf wayland.enable {
  # Install additional dependencies.
  home.packages = builtins.attrValues {
    inherit (pkgs)
      spotify
      vesktop
      ;
  };

  # Enable sway, see: https://swaywm.org/
  wayland.windowManager.sway = {
    enable = true;

    # Enable GTK application support.
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = "Mod4";

      startup = [
        # Ensure 'waybar' is running on startup.
        { command = "exec uwsm app -- waybar"; }
        # Autostart applications in specific workspaces.
        { command = "exec sh -c '${autostart}'"; }
      ];

      # Disable annoying 'swaybar'.
      bars = [ ];

      input."type:keyboard" = {
        #
        # ---- XKB ----
        #
        # Set the keyboard variant.
        xkb_variant = keyboard.variant;
        # Set the keyboard layout.
        xkb_layout = keyboard.layout;

        #
        # ---- Keypress ----
        #
        # Set the repetition delay.
        repeat_delay = "250";
        # Set the repetition rate.
        repeat_rate = "60";
      };

      # Hide the cursor after 3 seconds.
      seat."*".hide_cursor = "3000";

      # Enable wrapping focus changes.
      focus.wrapping = "yes";

      keybindings = {
        #
        # ---- Window ----
        #
        # <MOD> + Q to kill window.
        "${modifier}+q" = "kill";
        # <MOD> + N to toggle floating.
        "${modifier}+n" = "floating toggle";
        # <MOD> + M to toggle fullscreen.
        "${modifier}+m" = "fullscreen toggle";

        #
        # ---- Application ----
        #
        # <MOD> + T to open $TERMINAL.
        "${modifier}+t" = "exec uwsm app -- ${env.TERMINAL or "foot"}";
        # <MOD> + F to open $BROWSER.
        "${modifier}+f" = "exec uwsm app -- ${env.BROWSER or "firefox"}";
        # <MOD< + <SPACE> to open rofi.
        "${modifier}+Space" = "exec rofi -show drun -show-icons";

        #
        # ---- Workspace ----
        #
        # <MOD> + 1 to switch workspace (1).
        "${modifier}+1" = "workspace 1";
        # <MOD> + 2 to switch workspace (2).
        "${modifier}+2" = "workspace 2";
        # <MOD> + 3 to switch workspace (3).
        "${modifier}+3" = "workspace 3";
        # <MOD> + 4 to switch workspace (4).
        "${modifier}+4" = "workspace 4";
        # <MOD> + 5 to switch workspace (5).
        "${modifier}+5" = "workspace 5";
        # <MOD> + 6 to switch workspace (6).
        "${modifier}+6" = "workspace 6";
        # <MOD> + 7 to switch workspace (7).
        "${modifier}+7" = "workspace 7";
        # <MOD> + 8 to switch workspace (8).
        "${modifier}+8" = "workspace 8";
        # <MOD> + 9 to switch workspace (9).
        "${modifier}+9" = "workspace 9";

        # <MOD> + <SHIFT> + 1 to move focused window to workspace (1).
        "${modifier}+Shift+1" = "move container to workspace 1";
        # <MOD> + <SHIFT> + 2 to move focused window to workspace (2).
        "${modifier}+Shift+2" = "move container to workspace 2";
        # <MOD> + <SHIFT> + 3 to move focused window to workspace (3).
        "${modifier}+Shift+3" = "move container to workspace 3";
        # <MOD> + <SHIFT> + 4 to move focused window to workspace (4).
        "${modifier}+Shift+4" = "move container to workspace 4";
        # <MOD> + <SHIFT> + 5 to move focused window to workspace (5).
        "${modifier}+Shift+5" = "move container to workspace 5";
        # <MOD> + <SHIFT> + 6 to move focused window to workspace (6).
        "${modifier}+Shift+6" = "move container to workspace 6";
        # <MOD> + <SHIFT> + 7 to move focused window to workspace (7).
        "${modifier}+Shift+7" = "move container to workspace 7";
        # <MOD> + <SHIFT> + 8 to move focused window to workspace (8).
        "${modifier}+Shift+8" = "move container to workspace 8";
        # <MOD> + <SHIFT> + 9 to move focused window to workspace (9).
        "${modifier}+Shift+9" = "move container to workspace 9";

        # <MOD> + <SHIFT> + L to move focused window (R).
        "${modifier}+Shift+l" = "move right";
        # <MOD> + <SHIFT> + H to move focused window (L).
        "${modifier}+Shift+h" = "move left";

        # <MOD> + <TAB> to cycle focus (NEXT).
        "${modifier}+Tab" = "focus next";
        # <MOD> + <TAB> to cycle focus (PREV).
        "${modifier}+Shift+Tab" = "focus prev";

        #
        # ---- Volume Control ----
        #
        # <XF86AudioRaiseVolume> to increase volume.
        "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
        # <XF86AudioLowerVolume> to decrease volume.
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        # <XF86AudioMute> to mute volume.
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

        #
        # ---- Miscellaneous ----
        #
        # <MOD> + <SHIFT> + Q to exit sway.
        "${modifier}+Shift+q" = "exit";
      };
    };
  };
}
