-- indent-blankline.nvim: https://github.com/lukas-reineke/indent-blankline.nvim

local has_indent_blankline, indent_blankline = pcall(require, 'indent_blankline')
if not has_indent_blankline then return end

indent_blankline.setup {
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
  use_treesitter = true,
  use_treesitter_scope = true,
}
