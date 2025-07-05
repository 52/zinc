{
  pkgs,
  ...
}:
{
  # set default editor
  home.sessionVariables.EDITOR = "vim";

  # enable vim, see: https://www.vim.org/
  programs.vim = {
    enable = true;

    # use 'vim-custom' from 'github:52/vim'
    package = pkgs.vim-custom;
  };
}
