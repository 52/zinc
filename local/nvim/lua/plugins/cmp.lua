--
--
-- SPDX-License-Identifier: MIT
-- Author: Max Karou <maxkarou@protonmail.com>
-- URL: https://github.com/52/mkOS
--

require('blink-cmp').setup {
  completion = {
    list = {
      selection = function(ctx)
        return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect'
      end,
    },
    menu = {
      auto_show = true,
      draw = {
        gap = 2,
        columns = {
          { 'kind_icon', 'kind', gap = 1 },
          { 'label', 'label_description', gap = 1 },
          { 'source_name' },
        },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
    },
  },
  keymap = {
    ['<Tab>'] = {
      'select_next',
      'snippet_forward',
      'fallback',
    },
    ['<S-Tab>'] = {
      'select_prev',
      'snippet_backward',
      'fallback',
    },
    ['<CR>'] = {
      'accept',
      'fallback',
    },
    ['<C-N>'] = {
      'select_next',
      'show',
    },
    ['<C-P>'] = {
      'select_prev',
      'show',
    },
    ['<C-J>'] = {
      'select_next',
      'show',
    },
    ['<C-K>'] = {
      'select_prev',
      'show',
    },
    ['<C-Space>'] = {
      'show',
      'show_documentation',
      'hide_documentation',
    },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'normal',
    kind_icons = {
      Text = '󰉿',
      Snippet = '󰞘',
      File = '',
      Folder = '󰉋',
      Method = '󰊕',
      Function = '󰡱',
      Constructor = '',
      Field = '󰇽',
      Variable = '󰀫',
      Class = '󰜁',
      Interface = '',
      Module = '',
      Property = '󰜢',
      Unit = '',
      Value = '󰎠',
      Enum = '',
      Keyword = '󰌋',
      Color = '󰏘',
      Reference = '',
      EnumMember = '',
      Constant = '󰏿',
      Struct = '󰙅',
      Event = '',
      Operator = '󰆕',
      TypeParameter = '󰅲',
    },
  },
}
