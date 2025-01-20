--
--
-- SPDX-License-Identifier: MIT
-- Author: Max Karou <maxkarou@protonmail.com>
-- URL: https://github.com/52/mkOS
--

local lush = require 'lush'
local hsl = lush.hsl

local colors = {
  -- base
  bg = '#141414',
  fg = '#cccccc',
}

---@diagnostic disable: undefined-global
local specs = lush.parse(function()
  return {
    Normal { bg = hsl(colors.bg), fg = hsl(colors.fg) },
    NormalFloat { bg = Normal.bg.da(5), fg = Normal.fg.da(20) },
    NormalNC { bg = Normal.bg, fg = Normal.fg.da(20) },

    Cursor { bg = Normal.fg.li(50), fg = Normal.bg },
    CursorLine { bg = Normal.bg.li(8) },
    CursorLineNr { fg = Normal.fg.li(50) },

    Comment { fg = Normal.fg.da(60) },
  }
end)

lush.apply(lush.compile(specs))
