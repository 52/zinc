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
        font = "monospace:size=16";

        # Copy to primary and clipboard on select.
        selection-target = "both";

        # <todo>
        pad = "5x5";
      };

      # <todo>
      scrollback.lines = 50000;

      # <todo>
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
