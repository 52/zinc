--
--
-- SPDX-License-Identifier: MIT
-- Author: Max Karou <maxkarou@protonmail.com>
-- URL: https://github.com/52/mOS
--

local M = {}

M.require_env = function(name)
  local value = os.getenv(name)
  if value == nil then
    error("Required environment variable '" .. name .. "' is not set")
  end
  return value
end

M.bind = function(keys, func, desc, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, keys, func, { desc = desc })
end

return M
