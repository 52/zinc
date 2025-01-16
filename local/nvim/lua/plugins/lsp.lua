--
-- SPDX-License-Identifier: MIT
-- Author: Max Karou <maxkarou@protonmail.com>
-- URL: https://github.com/52/mkOS
--

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

-- lsp diagnostic
local signs = { Error = 'x', Warn = '!', Hint = '?', Info = 'i' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

vim.diagnostic.config {
  virtual_text = {
    prefix = '■',
  },
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('MKLspAttach', { clear = true }),
  callback = function(event)
    local lib = require 'lib'
    local bind = lib.bind

    -- lsp bindings
    bind('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    bind('<leader>gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    bind('<leader>gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    bind('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

    -- lsp highlight
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('MKLSPHighlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('MKLSPDetach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds {
            group = 'MKLSPHighlight',
            buffer = event2.buf,
          }
        end,
      })
    end
  end,
})
