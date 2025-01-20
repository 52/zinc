--
--
-- SPDX-License-Identifier: MIT
-- Author: Max Karou <maxkarou@protonmail.com>
-- URL: https://github.com/52/mkOS
--

require('lint').linters_by_ft = {
  nix = { 'nix', 'statix', 'deadnix' },
}

-- lint autocmds
vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost' }, {
  callback = function()
    require('lint').try_lint()
  end,
})
