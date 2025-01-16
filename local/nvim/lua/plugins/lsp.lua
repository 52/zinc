--
--
-- SPDX-License-Identifier: MIT
-- Author: Max Karou <maxkarou@protonmail.com>
-- URL: https://github.com/52/mkOS
--

local lib = require 'lib'
local bind = lib.bind

local lspconfig = require 'lspconfig'
local capabilities = require('blink.cmp').get_lsp_capabilities()

local setup = function(name, opts)
  local merged_opts = vim.tbl_extend('force', {
    capabilities = capabilities,
  }, opts or {})
  lspconfig[name].setup(merged_opts)
end

-- lsp definitions
setup 'nixd'
setup 'lua_ls'
setup 'rust_analyzer'

-- lsp bindings
bind('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
bind('<leader>gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
bind('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
