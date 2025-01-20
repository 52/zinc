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
  winopts = {
    height = 0.40,
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
