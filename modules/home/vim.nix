{
  pkgs,
  ...
}:
{
  # enable vim, see: https://www.vim.org/
  home = {
    # set default editor
    sessionVariables.EDITOR = "vim";

    # install 'vim-custom' from 'github:52/vim'
    packages = builtins.attrValues {
      inherit (pkgs)
        vim-custom
        ;
    };
  };
}
