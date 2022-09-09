---------------------------------------
-- Plugin manager configuration file --
---------------------------------------

local fn = vim.fn
local cmd = vim.cmd
local api = vim.api

-- Automatically install packer
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path
  })
  cmd [[packadd packer.nvim]]
  print "Packer has been installed."
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
  },
}

-- Automatically refresh Packer when config changes
local packer_autocmd_name = 'packer_user'
local has_packer_autocmd, _ = pcall(api.nvim_get_autocmds, { group = packer_autocmd_name })
if not has_packer_autocmd then
  api.nvim_create_autocmd('BufWritePost', {
    pattern = { 'packer_init.lua' },
    group = api.nvim_create_augroup(packer_autocmd_name, {}),
    callback = function()
      cmd [[PackerCompile]]
      print 'ℹ️ Packer has been re-generated'
    end,
  })
end

-- Utility to get require call for plugin configurations
function setup(name)
  return string.format('require("setup/%s")', name)
end

-- Install plugins
return packer.startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- File explorer
  use {
    'kyazdani42/nvim-tree.lua',
    config = setup('nvim-tree'),
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    },
    config = setup('telescope'),
  }

  -- Treesitter interface
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function ()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
  }

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = setup('lsp'),
  }
  use 'onsails/lspkind.nvim'

  -- Autocomplete
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      {'L3MON4D3/LuaSnip', tag = 'v<CurrentMajor>.*'},
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
    config = setup('cmp'),
  }

  -- External tooling manager (LSP, DAP, linters, formatters)
  use {
    'williamboman/mason.nvim',
    requires = {
      'williamboman/mason-lspconfig.nvim',
    },
    config = setup('mason'),
  }

  -- Auto pairs
  use {
    'windwp/nvim-autopairs',
    config = setup('nvim-autopairs'),
  }

  -- Icons
  use 'kyazdani42/nvim-web-devicons'

  -- Git labels
  use {
    'lewis6991/gitsigns.nvim',
    config = setup('gitsigns'),
  }

  -- Indent line
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = setup('indent_blankline'),
  }

  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = setup('lualine'),
  }

  -- Tabs
  use {
    'romgrk/barbar.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = setup('barbar'),
  }

  -- Color Scheme
  use {
    'catppuccin/nvim',
    as = 'catppuccin',
    config = setup('catppuccin'),
  }

  -- Startup screen
  use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = setup('alpha'),
  }

  -- Language-specific tooling
  use 'simrat39/rust-tools.nvim'

  -- Debug Adapter Protocol Client
  use {
    'mfussenegger/nvim-dap'
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
