{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
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
        nixvim = {
          enable = true;
          enableMan = false;
          performance = {
            byteCompileLua = {
              enable = true;
              configs = true;
              initLua = true;
              plugins = true;
              nvimRuntime = true;
            };
          };
          globals = {
            # leader
            mapleader = ",";
            maplocalleader = ",";
          };
          opts = {
            # editor
            hidden = true;
            showcmd = true;
            showmode = true;
            autoread = true;
            visualbell = true;
            signcolumn = "yes";
            # lines
            number = true;
            relativenumber = true;
            # cursor
            cursorline = true;
            guicursor = "a:block-Cursor";
            # text
            wrap = false;
            textwidth = 80;
            scrolloff = 10;
            sidescrolloff = 10;
            # indent
            cindent = true;
            cinkeys = "0{,0},0),0],:,!^F,o,O,e";
            autoindent = false;
            smartindent = false;
            expandtab = true;
            smarttab = true;
            # tabs
            shiftwidth = 2;
            softtabstop = 2;
            tabstop = 2;
            # search
            hlsearch = true;
            incsearch = true;
            smartcase = true;
            ignorecase = true;
            # split
            splitbelow = true;
            splitright = true;
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
          plugins = {
            lsp = {
              enable = true;
              servers = {
                nixd = {
                  enable = true;
                };
              };
            };
            cmp = {
              enable = true;
              autoEnableSources = true;
              settings = {
                sources = [
                  { name = "treesitter"; }
                  { name = "nvim_lsp"; }
                  { name = "buffer"; }
                  { name = "path"; }
                ];
                mapping = {
                  # select
                  "<CR>" = "cmp.mapping.confirm { select = true }";
                  "<Tab>" = "cmp.mapping.select_next_item()";
                  "<S-Tab>" = "cmp.mapping.select_prev_item()";
                  # manual
                  "<C-,>" = "cmp.mapping.complete()";
                  # docs
                  "<C-h>" = "cmp.mapping.open_docs()";
                  "<C-b>" = "cmp.mapping.scroll_docs(-4)";
                  "<C-f>" = "cmp.mapping.scroll_docs(4)";
                };
              };
            };
            lint = {
              enable = true;
              lintersByFt = {
                nix = [
                  "nix"
                  "statix"
                  "deadnix"
                ];
              };
            };
            treesitter = {
              enable = true;
              settings = {
                highlight = {
                  enable = true;
                };
              };
            };
            conform-nvim = {
              enable = true;
              settings = {
                format_on_save = {
                  lspFallback = true;
                  timeoutMs = 500;
                };
                formatters_by_ft = {
                  nix = [ "nixfmt" ];
                };
              };
            };
            fzf-lua = {
              enable = true;
              settings = {
                winopts = {
                  split = "botright 12new";
                  preview = {
                    hidden = "hidden";
                  };
                };
                buffers = {
                  no_header_i = true;
                  file_icons = false;
                  git_icons = false;
                };
                files = {
                  no_header_i = true;
                  file_icons = false;
                  git_icons = false;
                };
                grep = {
                  no_header_i = true;
                  file_icons = false;
                  git_icons = false;
                };
                git = {
                  no_header_i = true;
                  file_icons = false;
                  git_icons = false;
                };
              };
              keymaps = {
                "<leader>ff" = {
                  action = "files";
                  options = {
                    desc = "[F]ind [F]iles";
                    silent = true;
                  };
                };
                "<leader>lb" = {
                  action = "buffers";
                  options = {
                    desc = "[L]ist active [B]uffers";
                    silent = true;
                  };
                };
                "<leader>gb" = {
                  action = "grep_curbuf";
                  options = {
                    desc = "[G]rep in current [B]uffer";
                    silent = true;
                  };
                };
                "<leader>gl" = {
                  action = "live_grep";
                  options = {
                    desc = "Search files with [G]rep [L]ive";
                    silent = true;
                  };
                };
              };
            };
            nvim-autopairs = {
              enable = true;
            };
          };
          extraPackages = with pkgs; [
            # nix
            nixfmt-rfc-style
            deadnix
            statix
          ];
          highlight = with home-style; {
            Normal = {
              bg = colors.base00;
              fg = colors.base05;
            };
            Comment = {
              fg = colors.base03;
            };
            CursorLine = {
              bg = colors.base01;
            };
            LineNr = {
              fg = colors.base03;
            };
            CursorLineNr = {
              fg = colors.base05;
            };
            Visual = {
              bg = colors.base01;
            };
          };
          clipboard = {
            register = "unnamedplus";
          };
        };
      };
    };
}
