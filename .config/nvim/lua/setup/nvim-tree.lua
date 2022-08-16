-- nvim-tree.lua: https://github.com/kyazdani42/nvim-tree.lua

local has_nvim_tree, nvim_tree = pcall(require, 'nvim-tree')
if not has_nvim_tree then return end

-- See :help nvim-tree-setup
nvim_tree.setup {
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
}

-- Integrate with bufferline
local nvim_tree_events = require('nvim-tree.events')
local bufferline_state = require('bufferline.state')

local function get_tree_size()
  return require('nvim-tree.view').View.width
end

nvim_tree_events.subscribe('TreeOpen', function()
  bufferline_state.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('Resize', function()
  bufferline_state.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('TreeClose', function()
  bufferline_state.set_offset(0)
end)
