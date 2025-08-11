{
  pkgs,
  ...
}:
{
  # Set the default editor.
  env.EDITOR = "vim";

  # Enable "vim".
  # See: https://www.vim.org
  home.packages = builtins.attrValues {
    inherit (pkgs)
      vix
      ;
  };
}
