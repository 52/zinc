--
--
-- SPDX-License-Identifier: MIT
-- Author: Max Karou <maxkarou@protonmail.com>
-- URL: https://github.com/52/mOS
--

require('blink-cmp').setup {
  completion = {
    list = {
      selection = function(ctx)
        return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect'
      end,
    },
    menu = {
      max_height = 20,
      min_width = 25,
      border = 'none',
      scrolloff = 2,
      scrollbar = true,
      auto_show = true,
      draw = {
        columns = {
          { 'kind_icon' },
          { 'label', 'label_description', gap = 1 },
          { 'source_name' },
        },
        components = {
          source_name = {
            width = { max = 30 },
            text = function(ctx)
              return string.format('[%s]', ctx.source_name)
            end,
            highlight = 'BlinkCmpSource',
          },
        },
      },
    },
    documentation = {
      auto_show = false,
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
    nerd_font_variant = 'normal',
    kind_icons = {
      Method = '',
      Function = 'ƒ',
      Variable = '',
      Field = '',
      TypeParameter = '',
      Constant = '',
      Class = '',
      Interface = '',
      Struct = '',
      Event = '',
      Operator = '󰆕',
      Module = '󰅩',
      Property = '',
      Enum = '',
      Reference = '',
      Keyword = '',
      File = '',
      Folder = '󰝰',
      Color = '',
      Unit = '󰑭',
      Snippet = '',
      Text = '',
      Constructor = '',
      Value = '󰎠',
      EnumMember = '',
    },
  },
}
