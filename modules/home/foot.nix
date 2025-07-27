{ ... }:
{
  # Set the default terminal.
  env.TERMINAL = "foot";

  # Enable foot, see: https://codeberg.org/dnkl/foot/
  programs.foot = {
    enable = true;

    settings = {
      main = {
        # Set the primary font.
        font = "monospace:size=18";

        # Adjust vertical letter offset.
        vertical-letter-offset = "1.0";

        # Copy to primary and clipboard on select.
        selection-target = "both";

        # Set the window padding.
        pad = "8x12";
      };

      # Set scrollback history.
      scrollback.lines = 50000;

      # Make cursor blink.
      cursor.blink = "yes";

      key-bindings = {
        # Clipboard.
        clipboard-copy = "Super+c";
        clipboard-paste = "Super+p";

        # Fonts.
        font-increase = "Super+plus";
        font-decrease = "Super+minus";
      };

      # Set the colorscheme.
      colors = {
        background = "1c1c1c";
        foreground = "f6f6f6";
      };
    };
  };
}
