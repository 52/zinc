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
        font = "monospace:size=14";

        # Copy to primary and clipboard on select.
        selection-target = "both";
      };

      key-bindings = {
        # Clipboard.
        clipboard-copy = "Super+c";
        clipboard-paste = "Super+v";

        # Fonts.
        font-increase = "Super+plus";
        font-decrease = "Super+minus";
      };
    };
  };
}
