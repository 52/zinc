--
--
-- SPDX-License-Identifier: MIT
-- Author: Max Karou <maxkarou@protonmail.com>
-- URL: https://github.com/52/mkOS
--

local lib = require 'lib'
local bind = lib.bind

vim.g.compile_mode = { default_command = '' }

local function focus_compilation()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'compilation' then
      vim.api.nvim_set_current_win(win)
      break
    end
  end
end

local function compile()
  vim.ui.input({
    prompt = 'Compile: ',
    default = vim.g.compile_mode.default_command,
  }, function(input)
    if input then
      vim.g.compile_mode.default_command = input
      vim.cmd('Compile ' .. input)
      vim.defer_fn(focus_compilation, 10)
    end
  end)
end

bind('<leader>cc', compile, '[C]ompile Mode')
