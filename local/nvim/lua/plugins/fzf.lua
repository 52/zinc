--
--
-- SPDX-License-Identifier: MIT
-- Author: Max Karou <maxkarou@protonmail.com>
-- URL: https://github.com/52/mkOS
--

local lib = require 'lib'
local bind = lib.bind

require('fzf-lua').setup {
  fzf_opts = {
    ['--marker'] = '+',
    ['--pointer'] = '>',
  },
  fzf_colors = {
    ['fg'] = { 'fg', 'TelescopeNormal' },
    ['bg'] = { 'bg', 'TelescopeNormal' },
    ['hl'] = { 'fg', 'TelescopeMatching' },
    ['fg+'] = { 'fg', 'TelescopeSelection' },
    ['bg+'] = { 'bg', 'TelescopeSelection' },
    ['hl+'] = { 'fg', 'TelescopeMatching' },
    ['info'] = { 'fg', 'TelescopeMultiSelection' },
    ['border'] = { 'fg', 'TelescopeBorder' },
    ['gutter'] = '-1',
    ['query'] = { 'fg', 'TelescopePromptNormal' },
    ['prompt'] = { 'fg', 'TelescopePromptPrefix' },
    ['pointer'] = { 'fg', 'TelescopeSelectionCaret' },
    ['marker'] = { 'fg', 'TelescopeSelectionCaret' },
    ['header'] = { 'fg', 'TelescopeTitle' },
  },
  winopts = {
    height = 0.30,
    width = 1.00,
    row = 1.00,
    col = 0.5,
    backdrop = false,
    border = 'rounded',
    preview = {
      hidden = 'hidden',
    },
  },
  defaults = {
    git_icons = false,
    no_header_i = true,
  },
}

-- fzf bindings
local fzf = require 'fzf-lua'
bind('<leader>ff', fzf.files, '[F]ind [F]iles')
bind('<leader>fg', fzf.git_files, '[F]ind [G]it Files')
bind('<leader>fb', fzf.buffers, '[F]ind [B]uffers')
bind('<leader>gf', fzf.live_grep, '[G]rep [F]iles')
bind('<leader>gb', fzf.grep_curbuf, '[G]rep in [B]uffer')
