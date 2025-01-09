{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
in
{
  imports = map lib.custom.relativeToRoot [
    "home/hyprpaper.nix"
    "home/hyprlock.nix"
    "home/waybar.nix"
    "home/dunst.nix"
    "home/rofi.nix"
  ];
  options = {
    hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config =
    let
      inherit (config) hyprland style home;
      inherit (home) sessionVariables;
      inherit (osConfig) system;
      inherit (style) colors;
    in
    mkIf hyprland.enable {
      wayland = {
        windowManager = {
          hyprland = {
            inherit (hyprland) enable;
            settings = {
              monitor = "DP-1, 3840x1600@144, auto, 1";
              input = {
                # keyboard
                kb_layout = system.keyboard.layout;
                kb_variant = system.keyboard.variant;
                follow_mouse = 2;
                mouse_refocus = false;
                # keypress repeat
                repeat_rate = 60;
                repeat_delay = 250;
              };
              cursor = {
                # hide mouse after x/s
                inactive_timeout = 10;
              };
              general = {
                # gaps
                gaps_in = 10;
                gaps_out = 10;
                # border
                border_size = 2;
                resize_on_border = true;
                hover_icon_on_border = true;
                "col.inactive_border" = "rgb(${lib.strings.removePrefix "#" colors.base01})";
                "col.active_border" = "rgb(${lib.strings.removePrefix "#" colors.base02})";
                # hy3 (plugin)
                layout = "hy3";
              };
              decoration = {
                # transparency
                active_opacity = 1.0;
                inactive_opacity = 1.0;
                fullscreen_opacity = 1.0;
                # border
                rounding = 4;
              };
              misc = {
                middle_click_paste = false;
                animate_manual_resizes = true;
                animate_mouse_windowdragging = true;
              };
              # workspaces
              workspace = [
                "1, monitor:DP-1, persistent:true, default:true"
                "2, monitor:DP-1, persistent:true"
                "3, monitor:DP-1, persistent:true"
                "4, monitor:DP-1, persistent:true"
                "5, monitor:DP-1, persistent:true"
                "6, monitor:DP-1, persistent:true"
              ];
              # launch commands
              exec-once = [
                "${pkgs.waybar}/bin/waybar"
              ];
              # mouse binds
              bindm = [
                # <SUPER> + left-click (hold) to move a window
                "SUPER, mouse:272, moveWindow"
                # <SUPER> + right-click (hold) to resize a window
                "SUPER, mouse:273, resizeWindow"
              ];
              # repeat binds
              binde = [
                # <XF86AudioRaiseVolume> to increase volume
                ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
                # <XF86AudioLowerVolume> to decrease volume
                ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              ];
              # normal binds
              bind = [
                #
                # ---- Window ----
                #
                # <SUPER> + Q to kill window
                "SUPER, Q, killactive,"
                # <SUPER> + V to toggle floating
                "SUPER, V, togglefloating,"
                # <SUPER> + M to toggle fullscreen
                "SUPER, M, fullscreen"

                #
                # ---- Applications ----
                #
                # <SUPER> + T to open $TERMINAL
                "SUPER, T, exec, ${sessionVariables.TERMINAL}"
                # <SUPER> + F to open $BROWSER
                "SUPER, F, exec, ${sessionVariables.BROWSER}"
                # <SUPER> + <SPACE> to open rofi (drun)
                "SUPER, SPACE, exec, rofi -show drun"

                #
                # ---- Navigation ----
                #
                # <SUPER> + 0 to switch workspace (0)
                "SUPER, 0, workspace, 0"
                # <SUPER> + 1 to switch workspace (1)
                "SUPER, 1, workspace, 1"
                # <SUPER> + 2 to switch workspace (2)
                "SUPER, 2, workspace, 2"
                # <SUPER> + 3 to switch workspace (3)
                "SUPER, 3, workspace, 3"
                # <SUPER> + 4 to switch workspace (4)
                "SUPER, 4, workspace, 4"
                # <SUPER> + 5 to switch workspace (5)
                "SUPER, 5, workspace, 5"
                # <SUPER> + 6 to switch workspace (6)
                "SUPER, 6, workspace, 6"
                # <SUPER> + <SHIFT> + 0 to move focused window to workspace (0)
                "SUPER_SHIFT, 0, movetoworkspace, 0"
                # <SUPER> + <SHIFT> + 1 to move focused window to workspace (1)
                "SUPER_SHIFT, 1, movetoworkspace, 1"
                # <SUPER> + <SHIFT> + 2 to move focused window to workspace (2)
                "SUPER_SHIFT, 2, movetoworkspace, 2"
                # <SUPER> + <SHIFT> + 3 to move focused window to workspace (3)
                "SUPER_SHIFT, 3, movetoworkspace, 3"
                # <SUPER> + <SHIFT> + 4 to move focused window to workspace (4)
                "SUPER_SHIFT, 4, movetoworkspace, 4"
                # <SUPER> + <SHIFT> + 5 to move focused window to workspace (5)
                "SUPER_SHIFT, 5, movetoworkspace, 5"
                # <SUPER> + <SHIFT> + 6 to move focused window to workspace (6)
                "SUPER_SHIFT, 6, movetoworkspace, 6"
                # <SUPER> + up to move focus (up)
                "SUPER, up, movefocus, u"
                # <SUPER> + down to move focus (down)
                "SUPER, down, movefocus, d"
                # <SUPER> + right to move focus (right)
                "SUPER, left, movefocus, r"
                # <SUPER> + left to move focus (left)
                "SUPER, left, movefocus, l"
                # <SUPER> + Tab to cycle focus
                "SUPER, Tab, cyclenext"
                # <SUPER> + <SHIFT> + Tab to cycle focus (reverse)
                "SUPER_SHIFT, Tab, cyclenext, prev"

                # ---- Media ----
                #
                # <XF86AudioMute> to toggle audio mute
                ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

                #
                # ---- Misc ----
                #
                # <SUPER> + l to lock the wm
                "SUPER, l, exec, hyprlock"
              ];
            };
          };
        };
      };
    };
}
