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
      inherit (config) nvim xdg style;
      inherit (style) colors;
    in
    mkIf nvim.enable {
      programs = {
        neovim = {
          enable = true;
          extraLuaConfig = ''
            -- leader
            vim.g.mapleader = ','
            vim.g.maplocalleader = ','

            -- editor
            vim.opt.number = true
            vim.opt.relativenumber = true

            vim.opt.cursorline = true
            vim.opt.guicursor = 'a:block'

            vim.opt.ignorecase = true
            vim.opt.smartcase = true
            vim.opt.incsearch = true
            vim.opt.hlsearch = true

            vim.opt.tabstop = 2
            vim.opt.softtabstop = 2
            vim.opt.shiftwidth = 2

            vim.opt.expandtab = true
            vim.opt.smartindent = true

            vim.opt.wrap = false
            vim.opt.scrolloff = 10
            vim.opt.signcolumn = 'yes'

            vim.opt.splitright = true
            vim.opt.splitbelow = true

            vim.opt.foldenable = false
            vim.opt.foldmethod = 'manual'
            vim.opt.foldlevelstart = 99

            vim.opt.undofile = true
            vim.opt.undolevels = 10000
            vim.opt.undoreload = 10000
            vim.opt.undodir = "${xdg.configHome}/vim/vimundo"

            vim.opt.backup = true
            vim.opt.backupdir = "${xdg.configHome}/vim/backup"

            vim.opt.swapfile = true
            vim.opt.directory = "${xdg.configHome}/vim/swap"

            vim.opt.lazyredraw = true
            vim.opt.updatetime = 50
            vim.opt.timeoutlen = 500

            vim.opt.background = 'dark'
            vim.opt.termguicolors = true

            vim.schedule(function()
                vim.opt.clipboard = 'unnamedplus'
            end)

            vim.opt.backspace = 'indent,eol,start'
            vim.opt.iskeyword:append('-')

            vim.opt.diffopt:append('iwhite')
            vim.opt.diffopt:append('algorithm:histogram')
            vim.opt.diffopt:append('indent-heuristic')

            -- functions
            local bind = function(keys, func, desc, mode)
              mode = mode or 'n'
              vim.keymap.set(mode, keys, func, { desc = 'LSP: ' .. desc })
            end
          '';
          plugins = concatLists [
            # stable plugins
            (with pkgs.vimPlugins; [
              {
                plugin = nvim-autopairs;
                type = "lua";
                config = ''
                  -- autopairs setup
                  require('nvim-autopairs').setup {}
                '';
              }
              {
                plugin = nvim-treesitter.withAllGrammars;
                type = "lua";
                config = ''
                  -- treesitter setup
                  require('nvim-treesitter.configs').setup {
                    highlight = { enable = true },
                    indent = { enable = false }
                  }
                '';
              }
              {
                plugin = nvim-lint;
                type = "lua";
                config = ''
                  -- lint setup
                  require('lint').linters_by_ft =  {
                    nix = { 'nix', 'statix', 'deadnix', }
                  }

                  vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
                    callback = function()
                      require("lint").try_lint()
                    end,
                  })
                '';
              }
              {
                plugin = conform-nvim;
                type = "lua";
                config = ''
                  -- conform setup
                  require('conform').setup({
                    format_on_save = {
                      timeout_ms = 500,
                      lsp_format = "fallback",
                    },
                    formatters_by_ft = {
                      nix = { 'nixfmt' }
                    }
                  })
                '';
              }
              {
                plugin = nvim-lspconfig;
                type = "lua";
                config = ''
                  -- lsp setup
                  local lspconfig = require('lspconfig')
                  local capabilities = require('blink.cmp').get_lsp_capabilities()

                  local setup = function(name, opts)
                    local merged_opts = vim.tbl_extend("force", {
                      capabilities = capabilities,
                    }, opts or {})
                    lspconfig[name].setup(merged_opts)
                  end

                  -- lsp definitions
                  setup('nixd')
                  setup('rust_analyzer')

                  -- lsp bindings
                  bind('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                  bind('<leader>gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                  bind('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
                '';
              }
              {
                plugin = fzf-lua;
                type = "lua";
                config = ''
                  -- fzf setup
                  require('fzf-lua').setup({
                    'fzf-native',
                    winopts = {
                      split = 'belowright 14new',
                    },
                    defaults = {
                      no_header_i = true,
                      previewer = false,
                    },
                  })

                  -- fzf bindings
                  local fzf = require 'fzf-lua'
                  bind('<leader>ff', fzf.files, '[F]ind [F]iles')
                  bind('<leader>fg', fzf.git_files, '[F]ind [G]it Files')
                  bind('<leader>fb', fzf.buffers, '[F]ind [B]uffers')
                  bind('<leader>gf', fzf.live_grep, '[G]rep [F]iles')
                  bind('<leader>gb', fzf.grep_curbuf, '[G]rep in [B]uffer')
                '';
              }
              {
                plugin = base16-nvim;
                type = "lua";
                config = ''
                  -- colorscheme setup
                  require("base16-colorscheme").setup({
                    base00 = '${colors.base00}',
                    base01 = '${colors.base01}', 
                    base02 = '${colors.base02}',
                    base03 = '${colors.base03}',
                    base04 = '${colors.base04}',
                    base05 = '${colors.base05}',
                    base06 = '${colors.base06}',
                    base07 = '${colors.base07}',
                    base08 = '${colors.base08}',
                    base09 = '${colors.base09}',
                    base0A = '${colors.base0A}',
                    base0B = '${colors.base0B}',
                    base0C = '${colors.base0C}',
                    base0D = '${colors.base0D}',
                    base0E = '${colors.base0E}',
                    base0F = '${colors.base0F}'
                  })
                '';
              }
            ])
            # unstable plugins
            (with pkgs.unstable.vimPlugins; [
              {
                plugin = blink-cmp;
                type = "lua";
                config = ''
                  -- cmp setup
                  require('blink-cmp').setup {}
                '';
              }
            ])
          ];
          extraPackages = attrValues {
            inherit (pkgs)
              nixfmt-rfc-style
              deadnix
              statix
              nixd
              ;
          };
        };
      };
    };
}
