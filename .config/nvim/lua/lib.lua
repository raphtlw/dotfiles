-----------------------------------------------------------
-- Reusable objects used across all files in this config --
-----------------------------------------------------------

local M = {}

function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }  -- Default options
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  if type(rhs) == 'string' then
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  elseif type(rhs) == 'function' then
    vim.keymap.set(mode, lhs, rhs, options)
  else
    error('Invalid call to map()')
  end
end

return M
