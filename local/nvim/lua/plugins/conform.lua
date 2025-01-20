--
--
-- SPDX-License-Identifier: MIT
-- Author: Max Karou <maxkarou@protonmail.com>
-- URL: https://github.com/52/mOS
--

require('conform').setup {
  format_on_save = {
    timeout_ms = 500,
    lsp_format = true,
  },
  formatters_by_ft = {
    nix = { 'nixfmt' },
    lua = { 'stylua' },
  },
}
