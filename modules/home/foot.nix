{ ... }:
{
  # enable foot, see: https://codeberg.org/dnkl/foot/
  programs.foot = {
    enable = true;

    # configure foot
    settings = {
      main = {
        # <todo>
        app-id = "foot";

        # <todo>
        font = "monospace:size=14";
      };
    };
  };
}
