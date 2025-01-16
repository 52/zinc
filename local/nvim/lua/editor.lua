--
--
-- SPDX-License-Identifier: MIT
-- Author: Max Karou <maxkarou@protonmail.com>
-- URL: https://github.com/52/mkOS
--

local lib = require 'lib'
local xdg_home = lib.require_env 'XDG_CONFIG_HOME'

-- leader
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- editor
vim.opt.number = true

vim.opt.cursorline = true
vim.opt.guicursor = 'a:block/,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'

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
vim.opt.undodir = xdg_home .. '/vim/vimundo'

vim.opt.backup = true
vim.opt.backupdir = xdg_home .. '/vim/backup'

vim.opt.swapfile = true
vim.opt.directory = xdg_home .. '/vim/swap'

vim.opt.lazyredraw = true
vim.opt.updatetime = 50
vim.opt.timeoutlen = 500

vim.opt.background = 'dark'
vim.opt.termguicolors = true

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.backspace = 'indent,eol,start'
vim.opt.iskeyword:append '-'

vim.opt.diffopt:append 'iwhite'
vim.opt.diffopt:append 'algorithm:histogram'
vim.opt.diffopt:append 'indent-heuristic'
