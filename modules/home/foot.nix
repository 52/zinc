{ ... }:
{
  # enable foot, see: https://codeberg.org/dnkl/foot/
  programs.foot = {
    enable = true;

    settings = {
      main = {
        # set primary font
        font = "monospace:size=14";

        # enable dpi-awareness (scaling)
        dpi-aware = "yes";
      };
    };
  };
}
