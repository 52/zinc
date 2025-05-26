--
--
-- SPDX-License-Identifier: MIT
-- Author: Max Karou <maxkarou@protonmail.com>
-- URL: https://github.com/52/mOS
--

local lib = require 'lib'
local bind_buf = lib.bind_buf
local bind = lib.bind

local M = {}

-- Creates a generic interface with input and output buffers.
--
-- @param lines fn(input: string): string[]
-- @param select_fn fn(selected: string)
function M.finder(lines, select_fn)
  local main_win = vim.api.nvim_get_current_win()

  -- create the input buffer
  local input_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(input_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(input_buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(input_buf, 'swapfile', false)

  -- create the output buffer
  local output_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(output_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(output_buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(output_buf, 'swapfile', false)
  vim.api.nvim_buf_set_option(output_buf, 'modifiable', false)

  -- create a bottom split window for the output buffer
  vim.cmd 'botright 15split'
  local output_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(output_win, output_buf)

  -- configure the output window appearance
  vim.api.nvim_win_set_option(output_win, 'cursorline', true)

  -- create a top split window for the input buffer
  vim.cmd 'aboveleft 1split'
  local input_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(input_win, input_buf)

  -- configure the output window appearance
  vim.api.nvim_win_set_option(input_win, 'number', false)
  vim.api.nvim_win_set_option(input_win, 'relativenumber', false)
  vim.api.nvim_win_set_option(input_win, 'winfixheight', true)

  -- track the currently selected line
  local current_line = 1

  -- <todo>
  local function tick()
    local input = vim.api.nvim_buf_get_lines(input_buf, 0, 1, false)[1] or ''
    local items = lines(input)
    vim.api.nvim_buf_set_option(output_buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, items)
    vim.api.nvim_buf_set_option(output_buf, 'modifiable', false)

    -- reset the cursor to the first line when the results change,
    -- this ensures the cursor always lands on a valid line
    current_line = 1
    if #items > 0 then
      vim.api.nvim_win_set_cursor(output_win, { current_line, 0 })
    end
  end

  -- <todo>
  local function close()
    -- close the input window
    if vim.api.nvim_win_is_valid(input_win) then
      vim.api.nvim_win_close(input_win, true)
    end

    -- close the output window
    if vim.api.nvim_win_is_valid(output_win) then
      vim.api.nvim_win_close(output_win, true)
    end

    -- switch to normal mode
    vim.cmd 'stopinsert'
  end

  -- <todo>
  local function move(delta)
    local line_count = vim.api.nvim_buf_line_count(output_buf)
    if line_count == 0 then
      return
    end

    current_line = math.min(math.max(current_line + delta, 1), line_count)
    vim.api.nvim_win_set_cursor(output_win, { current_line, 0 })
  end

  -- <todo>
  local function select_next()
    move(1)
  end

  -- <todo>
  local function select_prev()
    move(-1)
  end

  -- <todo>
  local function select_item()
    local selected = vim.api.nvim_buf_get_lines(output_buf, current_line - 1, current_line, false)[1]
    if selected and selected ~= '' then
      -- close the windows first
      close()

      -- switch to the main window
      vim.api.nvim_set_current_win(main_win)
      select_fn(selected)

      -- switch to normal mode
      vim.cmd 'stopinsert'
    end
  end

  -- <todo>
  vim.api.nvim_create_autocmd('TextChangedI', {
    buffer = input_buf,
    callback = tick,
  })

  -- <todo>
  vim.api.nvim_create_autocmd('WinClosed', {
    pattern = tostring(input_win),
    callback = close,
  })

  vim.api.nvim_create_autocmd('WinClosed', {
    pattern = tostring(output_win),
    callback = close,
  })

  -- <todo>
  bind_buf(input_buf, '<C-n>', select_next, 'Select next', 'i')
  bind_buf(input_buf, '<C-p>', select_prev, 'Select prev', 'i')
  bind_buf(input_buf, '<CR>', select_item, 'Select file', 'i')
  bind_buf(input_buf, '<Esc>', close, 'Close finder', 'i')

  -- <todo>
  tick()

  -- <todo>
  vim.api.nvim_set_current_win(input_win)
  vim.cmd 'startinsert'
end

-- <todo>
M.find_files = function()
  if vim.fn.executable 'fd' == 0 then
    vim.notify("[finder]: 'fd' is not installed.", vim.log.levels.ERROR)
    return
  end

  local function lines(input)
    local cmd = 'fd --type f --hidden --no-ignore ' .. vim.fn.shellescape(input)
    return vim.fn.systemlist(cmd)
  end

  local function select_fn(selected)
    vim.cmd('edit ' .. vim.fn.fnameescape(selected))
  end

  M.finder(lines, select_fn)
end

-- <todo>
M.find_files_git = function()
  if vim.fn.executable 'git' == 0 then
    vim.notify("[finder]: 'git' is not installed.", vim.log.levels.ERROR)
    return
  end

  local _ = vim.fn.system 'git rev-parse --git-dir 2>/dev/null'
  if vim.v.shell_error ~= 0 then
    vim.notify("[finder]: Not in a 'git' repository.", vim.log.levels.ERROR)
    return
  end

  local function lines(input)
    local cmd = 'git ls-files'
    local files = vim.fn.systemlist(cmd)

    if input == '' then
      return files
    end

    local filtered = {}
    for _, file in ipairs(files) do
      if file:find(input, 1, true) then
        table.insert(filtered, file)
      end
    end
    return filtered
  end

  local function select_fn(selected)
    vim.cmd('edit ' .. vim.fn.fnameescape(selected))
  end

  M.finder(lines, select_fn)
end

-- <todo>
M.find_buffer = function()
  local function lines(input)
    local buf_list = {}
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.fn.buflisted(bufnr) == 1 then
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:find(input, 1, true) then
          table.insert(buf_list, bufname)
        end
      end
    end
    return buf_list
  end

  local function select_fn(selected)
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_get_name(bufnr) == selected then
        vim.api.nvim_set_current_buf(bufnr)
        break
      end
    end
  end

  M.finder(lines, select_fn)
end

-- <todo>
M.grep_files = function()
  if vim.fn.executable 'rg' == 0 then
    vim.notify("[finder]: 'rg' is not installed.", vim.log.levels.ERROR)
    return
  end

  local function lines(input)
    if input == '' then
      return {}
    end

    local cmd = 'rg --no-heading --with-filename --line-number --column ' .. vim.fn.shellescape(input)
    return vim.fn.systemlist(cmd)
  end

  local function select_fn(selected)
    local file, line, col = selected:match '^([^:]+):(%d+):(%d+):'
    if file and line and col then
      vim.cmd('edit ' .. vim.fn.fnameescape(file))
      vim.api.nvim_win_set_cursor(0, { tonumber(line), tonumber(col) - 1 })
    end
  end

  M.finder(lines, select_fn)
end

-- <todo>
M.grep_buffer = function() end

-- finder bindings
bind('<leader>ff', M.find_files, '[F]inder: List all [F]iles')
bind('<leader>fg', M.find_files_git, '[F]inder: List all Files ([G]it)')
bind('<leader>fb', M.find_buffer, '[F]inder: List all [B]uffers')
bind('<leader>gf', M.grep_files, 'Finder: [G]rep all [F]iles (Git)')
bind('<leader>gb', M.grep_buffer, 'Finder: [G]rep active [B]uffer')

return M
