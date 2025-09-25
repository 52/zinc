{
  pkgs,
  ...
}:
{
  # Set the visual editor.
  env.VISUAL = "emacs";

  # Enable "GNU Emacs".
  # See: https://www.gnu.org/software/emacs
  home.packages = builtins.attrValues {
    inherit (pkgs)
      forge
      ;
  };
}
