{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    nvim = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config =
    let
      inherit (builtins) attrValues;
      inherit (lib) concatLists;
      inherit (config) nvim;
    in
    mkIf nvim.enable {
      xdg = {
        configFile = {
          "nvim" = {
            source = ../local/nvim;
            recursive = true;
          };
        };
      };
      programs = {
        neovim = {
          enable = true;
          plugins = concatLists [
            # stable plugins
            (with pkgs.vimPlugins; [
              nvim-autopairs
              nvim-treesitter.withAllGrammars
              nvim-lint
              nvim-lspconfig
            ])

            # unstable plugins
            (with pkgs.unstable.vimPlugins; [
              conform-nvim
            ])
          ];
          extraPackages = attrValues {
            inherit (pkgs)
              # nix
              nixfmt-rfc-style
              deadnix
              statix
              nixd

              # lua
              lua-language-server
              stylua
              ;
          };
        };
      };
    };
}
