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
              conform-nvim
              fzf-lua
            ])

            # unstable plugins
            (with pkgs.unstable.vimPlugins; [
              blink-cmp
            ])

            # extra plugins
            (with pkgs.vimExtraPlugins; [
              plenary-nvim
            ])

            # custom plugins
            (with pkgs.vimUtils; [
              (buildVimPlugin {
                name = "compile-mode";
                src = pkgs.fetchFromGitHub {
                  owner = "ej-shafran";
                  repo = "compile-mode.nvim";
                  rev = "v5.4.0";
                  sha256 = "sha256-ZCDxZcxyEapDB2korEecVslOKV5oPj5U9wudBtlP4x0=";
                };
              })
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
