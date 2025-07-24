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
        font = "monospace:size=24";

        # Copy to primary and clipboard on select.
        selection-target = "both";

        # Set the window padding.
        pad = "6x12";
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
    };
  };
}
