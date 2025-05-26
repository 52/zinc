--
--
-- SPDX-License-Identifier: MIT
-- Author: Max Karou <maxkarou@protonmail.com>
-- URL: https://github.com/52/mOS
--

local M = {}

-- Gets an enviroment variable or throws an error.
M.require_env = function(name)
  local value = os.getenv(name)
  if value == nil then
    error("Required environment variable '" .. name .. "' is not set")
  end
  return value
end

-- Set a key mapping with a description.
M.bind = function(keys, func, desc, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, keys, func, { desc = desc })
end

-- Set a buffer-local key mapping with a description.
M.bind_buf = function(buf, keys, func, desc, mode)
  mode = mode or 'n'
  vim.api.nvim_buf_set_keymap(buf, mode, keys, '', {
    callback = func,
    desc = desc,
    noremap = true,
  })
end

return M
