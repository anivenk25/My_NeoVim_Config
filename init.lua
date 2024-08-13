-- Show absolute line numbers
vim.wo.number = true

-- Show relative line numbers (optional)
vim.wo.relativenumber = true

-- Set leader key
vim.g.mapleader = " "

-- Install lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
local plugins = {
  -- Theme
  {"catppuccin/nvim", name = "catppuccin", priority = 1000},

  -- Fuzzy Finder
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- Syntax Highlighting
  {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},

  -- LSP Configurations
  {"neovim/nvim-lspconfig"},

  -- Autocompletion
  {"hrsh7th/nvim-cmp"},
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/cmp-buffer"},
  {"hrsh7th/cmp-path"},
  {"hrsh7th/cmp-cmdline"},
  {"L3MON4D3/LuaSnip"},
  {"saadparwaiz1/cmp_luasnip"},

  -- File Explorer (Folder Tree)
  {"nvim-tree/nvim-tree.lua"},
  {"kyazdani42/nvim-web-devicons"},  -- File icons

  -- Status Line
  {"nvim-lualine/lualine.nvim"},
  {"arkav/lualine-lsp-progress"},

  -- Git Integration
  {"lewis6991/gitsigns.nvim"},
  {"tpope/vim-fugitive"},

  -- Debugging (DAP)
  {"mfussenegger/nvim-dap"},
  {"rcarriga/nvim-dap-ui"},
  {"theHamsta/nvim-dap-virtual-text"},
  {"nvim-telescope/telescope-dap.nvim"},

  -- Required by nvim-dap-ui
  {"nvim-neotest/nvim-nio"},

  -- Terminal Integration
  {"akinsho/toggleterm.nvim"},

  -- Code Formatting
  {"jose-elias-alvarez/null-ls.nvim"},
  {"mhartington/formatter.nvim"},

  -- Auto Pairs
  {"windwp/nvim-autopairs"},

  -- Commenting
  {"numToStr/Comment.nvim"},

  -- File Search/Navigation
  {"nvim-telescope/telescope-file-browser.nvim"},
  
  -- Project Management
  {"ahmedkhalf/project.nvim"},

  -- Startup Screen
  {"goolord/alpha-nvim"},

  -- Markdown Preview
  {"iamcco/markdown-preview.nvim", run = "cd app && npm install"},

  -- Which Key (keybinding hints)
  {"folke/which-key.nvim"},

  -- Surround text with pairs
  {"tpope/vim-surround"},

  -- Better escape for terminal and insert modes
  {"max397574/better-escape.nvim"},

  -- Smooth scrolling
  {"karb94/neoscroll.nvim"},
}

local opts = {}
require("lazy").setup(plugins, opts)

-- Treesitter Configuration
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua", "python", "c", "cpp", "java", "ruby", "go", "rust", "typescript",
    "html", "css", "bash", "json", "yaml", "xml", "php", "perl", "swift",
    "kotlin", "r", "dart", "elixir", "erlang", "haskell", "scala", "vim",
    "markdown", "dockerfile", "toml", "graphql", "svelte", "vue", "sql",
    "latex"
  },
  highlight = { enable = true },
  indent = { enable = true },
})

-- LSP Config
local lspconfig = require("lspconfig")
lspconfig.pyright.setup{}
lspconfig.tsserver.setup{}
lspconfig.rust_analyzer.setup{}
lspconfig.gopls.setup{}
-- Add more LSP servers as needed

-- Telescope Keybindings
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- Nvim-Tree Setup
require("nvim-tree").setup()
vim.keymap.set('n', '<C-m>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })


-- Lualine Setup
require("lualine").setup{
  options = { theme = 'catppuccin' }
}

-- Gitsigns Setup
require("gitsigns").setup()

-- DAP UI Setup
require("dapui").setup()

-- ToggleTerm Setup
require("toggleterm").setup()

-- Auto Pairs Setup
require("nvim-autopairs").setup()

-- Comment.nvim Setup
require("Comment").setup()

-- Project.nvim Setup
require("project_nvim").setup()

-- Alpha-nvim Setup
require("alpha").setup(require("alpha.themes.startify").config)

-- Which Key Setup
require("which-key").setup()

-- Better Escape Setup
require("better_escape").setup()

-- Neoscroll Setup
require("neoscroll").setup()

-- Colorscheme
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

require('nvim-web-devicons').setup({
  default = true;
})