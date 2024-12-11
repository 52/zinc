{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.nvf.homeManagerModules.default ];
  options = {
    home-nvim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables the 'home-nvim' module.";
      };
    };
  };
  config =
    let
      inherit (config) home-nvim home-style;
      options = home-nvim;
    in
    lib.mkIf options.enable {
      assertions = [
        {
          assertion = options.enable -> home-style.enable;
          message = "home-nvim.enable requires an enabled 'home-style' module.";
        }
      ];
      programs = {
        nvf = {
          enable = true;
          settings = {
            vim = {
              globals = {
                # leader
                mapleader = " ";
                maplocalleader = " ";
              };
              options = {
                # editor
                hidden = true;
                showcmd = true;
                showmode = true;
                autoread = true;
                visualbell = true;
                # lines
                number = true;
                relativenumber = true;
                # cursor
                cursorline = true;
                guicursor = "a:block";
                # text
                wrap = false;
                textwidth = 80;
                scrolloff = 8;
                sidescrolloff = 10;
                # indent
                cindent = true;
                expandtab = true;
                autoindent = true;
                smartindent = true;
                breakindent = true;
                # search
                hlsearch = true;
                incsearch = true;
                smartcase = true;
                ignorecase = true;
                # fold
                foldenable = false;
                foldlevelstart = 99;
                foldmethod = "manual";
                # colors
                background = "dark";
                termguicolors = true;
                # backup
                backupdir = "${config.xdg.configHome}/vim/backup";
                directory = "${config.xdg.configHome}/vim/swap";
                # undo
                undofile = true;
                undolevels = 10000;
                undoreload = 10000;
                undodir = "${config.xdg.configHome}/vim/vimundo";
                # performance
                updatetime = 150;
                timeoutlen = 500;
                lazyredraw = true;
              };
              autocomplete = {
                nvim-cmp = {
                  enable = true;
                };
              };
              lsp = {
                formatOnSave = true;
              };
              languages = {
                enableLSP = true;
                enableFormat = true;
                enableTreesitter = true;
                enableExtraDiagnostics = true;
                nix = {
                  enable = true;
                  format = {
                    type = "nixfmt";
                  };
                };
                astro = {
                  enable = true;
                };
                lua = {
                  enable = true;
                };
              };
              extraPlugins = with pkgs; {
                mellifluous = {
                  package = vimUtils.buildVimPlugin {
                    name = "mellifluous-nvim";
                    src = fetchFromGitHub {
                      owner = "ramojus";
                      repo = "mellifluous.nvim";
                      rev = "3a31595e0965f577aff5de1a5f91e61a01daa903";
                      sha256 = "sha256-aPBDmXY1mya5ajIJ9K0PZxU8n2K7jbgo5XI8vkGqlUQ=";
                    };
                  };
                  setup = ''
                    -- mellifluous setup
                    require('mellifluous').setup({
                      mellifluous = {
                        color_overrides = {
                          dark = {
                            bg = function(bg)
                              return bg:darkened(4)
                            end,
                            colors = function(colors)
                              return {
                                fg = colors.fg:lightened(1),
                                shades_fg = colors.fg
                              }
                            end
                          },
                        },
                      },
                    })

                    -- set colorscheme
                    vim.cmd.colorscheme('mellifluous')
                  '';
                };
                nvim-autopairs = {
                  package = vimPlugins.nvim-autopairs;
                  setup = ''
                    require('nvim-autopairs').setup {}
                  '';
                };
                nvim-web-devicons = {
                  package = vimPlugins.nvim-web-devicons;
                  setup = ''
                    require('nvim-web-devicons').setup {}
                  '';
                };
                fzf-lua = {
                  package = vimPlugins.fzf-lua;
                  after = [ "nvim-web-devicons" ];
                  setup = ''
                    -- fzf setup
                    require('fzf-lua').setup {
                      winopts = {
                        split = 'botright 12new',
                        preview = {
                          hidden = 'hidden',
                        },
                      },
                      files = {
                        git_icons = false;
                        file_icons = false;
                        no_header_i = true;
                      },
                      buffers = {
                        git_icons = false;
                        file_icons = false;
                        no_header_i = true;
                      };
                    }

                    -- fzf keymap
                    local builtin = require('fzf-lua')
                    vim.keymap.set('n', '<leader>f', builtin.files, { desc = 'Find Files' })
                    vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Find active Buffers' }) 
                    vim.keymap.set('n', '<leader>pf', builtin.git_files, { desc = 'Find Files [Project]' })
                    vim.keymap.set('n', '<leader>pg', builtin.live_grep, { desc = 'Find by Grep [Project]' })
                    vim.keymap.set('n', '<leader>bg', builtin.grep_curbuf, { desc = 'Find by Grep [Buffer]' })
                  '';
                };
                lualine = {
                  package = vimPlugins.lualine-nvim;
                  after = [ "nvim-web-devicons" ];
                  setup = ''
                    require('lualine').setup { }
                  '';
                };
              };
              useSystemClipboard = true;
            };
          };
        };
      };
    };
}
