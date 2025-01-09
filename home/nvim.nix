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
      inherit (lib) concatLists;
      inherit (config) nvim xdg;
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

                  -- lint autocmds
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
                plugin = fzf-lua;
                type = "lua";
                config = ''
                  -- fzf setup
                  require('fzf-lua').setup({
                    winopts = {
                      split = 'botright 14new',
                    },
                    defaults = {
                      no_header_i = true,
                      file_icons = false,
                      git_icons = false,
                      previewer = false,
                    }
                  })

                  -- fzf bindings
                  local builtin = require 'fzf-lua'
                  vim.keymap.set('n', '<leader>ff', builtin.files, { desc = '[F]ind [F]iles' })
                  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
                  vim.keymap.set('n', '<leader>gf', builtin.live_grep, { desc = '[G]rep [F]iles' })
                  vim.keymap.set('n', '<leader>gb', builtin.grep_curbuf, { desc = '[G]rep [B]uffer' })
                '';
              }
            ])
            # unstable plugins
            (with pkgs.unstable.vimPlugins; [

            ])
          ];
        };
      };
    };
}
