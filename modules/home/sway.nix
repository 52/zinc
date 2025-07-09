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

  # Swayfocus is an extension to improve focus behaviour by
  # enabling wrapping focus changing within the current workspace.
  # For more context, see: https://github.com/swaywm/sway/issues/3974
  swayfocus = pkgs.writeShellScriptBin "swayfocus" ''
    # Verify the required packages.
    PACKAGES="swaymsg grep sed cut jq wc"
    for pkg in $PACKAGES; do
      if ! command -v "$pkg" > /dev/null 2>&1; then
        echo "Error: '$pkg' not found"
        exit 1
      fi
    done

    # Verify command arguments.
    if [ $# -ne 1 ] || [ "$1" != "next" -a "$1" != "prev" ]; then
      echo "Usage: $0 [next | prev]"
      exit 1
    fi

    # Focus cycle direction.
    DIRECTION=$1

    # List all visible windows in the current workspace.
    WINDOWS=$(swaymsg -t get_tree | jq -r '
      recurse(.nodes[]?, .floating_nodes[]?) |
      select(.type == "con" and .visible == true and (.app_id != null or .class != null)) |
      "\(.id):\(.focused)"
    ')

    # Count the number of visible windows.
    NUM_WINDOWS=$(echo "$WINDOWS" | wc -l)

    # Assert that more than one window is visible.
    if [ "$NUM_WINDOWS" -le 1 ]; then
      exit 0
    fi

    # Find focused window line number (1-based).
    CURRENT=$(echo "$WINDOWS" | grep -n ":true$" | cut -d: -f1)

    # Calculate the window target line number.
    if [ "$DIRECTION" = "next" ]; then
      TARGET=$(( CURRENT % NUM_WINDOWS + 1 ))
    else
      TARGET=$(( (CURRENT - 2 + NUM_WINDOWS) % NUM_WINDOWS + 1 ))
    fi

    # Extract the window identifier from the target line.
    ID=$(echo "$WINDOWS" | sed -n "''${TARGET}p" | cut -d: -f1)

    # Focus the target window.
    swaymsg "[con_id=$ID] focus" > /dev/null
  '';
in
mkIf wayland.enable {
  # Install user packages.
  home.packages = [ swayfocus ];

  # Enable sway, see: https://swaywm.org/
  wayland.windowManager.sway = {
    enable = true;

    config = rec {
      modifier = "Mod4";

      input."type:keyboard" = {
        # Set the keyboard layouts.
        xkb_layout = keyboard.layout;
        xkb_variant = keyboard.variant;

        # Enable faster typing speed.
        repeat_delay = "250";
        repeat_rate = "60";
      };

      keybindings = {
        #
        # ---- Window ----
        #
        # <MOD> + Q to kill window
        "${modifier}+q" = "kill";
        # <MOD> + N to toggle floating
        "${modifier}+n" = "floating toggle";
        # <MOD> + M to toggle fullscreen
        "${modifier}+m" = "fullscreen toggle";

        #
        # ---- Application ----
        #
        # <MOD> + T to open $TERMINAL
        "${modifier}+t" = "exec uwsm app -- ${env.TERMINAL or "foot"}";
        # <MOD> + F to open $BROWSER
        "${modifier}+f" = "exec uwsm app -- ${env.BROWSER or "firefox"}";

        #
        # ---- Workspace ----
        #
        # <MOD> + 1 to switch workspace (1)
        "${modifier}+1" = "workspace 1";
        # <MOD> + 2 to switch workspace (2)
        "${modifier}+2" = "workspace 2";
        # <MOD> + 3 to switch workspace (3)
        "${modifier}+3" = "workspace 3";
        # <MOD> + 4 to switch workspace (4)
        "${modifier}+4" = "workspace 4";
        # <MOD> + 5 to switch workspace (5)
        "${modifier}+5" = "workspace 5";
        # <MOD> + 6 to switch workspace (6)
        "${modifier}+6" = "workspace 6";
        # <MOD> + 7 to switch workspace (7)
        "${modifier}+7" = "workspace 7";
        # <MOD> + 8 to switch workspace (8)
        "${modifier}+8" = "workspace 8";
        # <MOD> + 9 to switch workspace (9)
        "${modifier}+9" = "workspace 9";

        # <MOD> + <SHIFT> + 1 to move focused window to workspace (1)
        "${modifier}+Shift+1" = "move container to workspace 1";
        # <MOD> + <SHIFT> + 2 to move focused window to workspace (2)
        "${modifier}+Shift+2" = "move container to workspace 2";
        # <MOD> + <SHIFT> + 3 to move focused window to workspace (3)
        "${modifier}+Shift+3" = "move container to workspace 3";
        # <MOD> + <SHIFT> + 4 to move focused window to workspace (4)
        "${modifier}+Shift+4" = "move container to workspace 4";
        # <MOD> + <SHIFT> + 5 to move focused window to workspace (5)
        "${modifier}+Shift+5" = "move container to workspace 5";
        # <MOD> + <SHIFT> + 6 to move focused window to workspace (6)
        "${modifier}+Shift+6" = "move container to workspace 6";
        # <MOD> + <SHIFT> + 7 to move focused window to workspace (7)
        "${modifier}+Shift+7" = "move container to workspace 7";
        # <MOD> + <SHIFT> + 8 to move focused window to workspace (8)
        "${modifier}+Shift+8" = "move container to workspace 8";
        # <MOD> + <SHIFT> + 9 to move focused window to workspace (9)
        "${modifier}+Shift+9" = "move container to workspace 9";

        # <MOD> + <TAB> to cycle focus
        "${modifier}+Tab" = "exec swayfocus next";
        # <MOD> + <TAB> to cycle focus (reverse)
        "${modifier}+Shift+Tab" = "exec swayfocus prev";

        #
        # ---- Volume Control ----
        #
        # <XF86AudioRaiseVolume> to increase volume
        "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
        # <XF86AudioLowerVolume> to decrease volume
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        # <XF86AudioMute> to toggle mute
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

        #
        # ---- Miscellaneous ----
        #
        # <MOD> + <SHIFT> + Q to exit sway
        "${modifier}+Shift+q" = "exit";
      };
    };
  };
}
