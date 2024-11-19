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

    -- Vim-be-good plugin (Vim practice game)
  {"ThePrimeagen/vim-be-good"},

  -- snacks plugins 
  {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    dashboard = 
	{enabled = true , 
	    sections = {
    { section = "header" },
    {
      pane = 2,
      section = "terminal",
      cmd = " /home/anirudh/ColorScripts/square",
      height = 5,
      padding = 1,
    },
    { section = "keys", gap = 1, padding = 1 },
    { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
    { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
    {
      pane = 2,
      icon = " ",
      title = "Git Status",
      section = "terminal",
      enabled = vim.fn.isdirectory(".git") == 1,
      cmd = "hub status --short --branch --renames",
      height = 5,
      padding = 1,
      ttl = 5 * 60,
      indent = 3,
    },
    { section = "startup" },
  },
				},
  },
},

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
  --{"goolord/alpha-nvim"},

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
  
  -- Undo Tree
  {"mbbill/undotree"},
}

local opts = {}
require("lazy").setup(plugins, opts)

-- Treesitter Configuration
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua", "python", "c", "cpp", "java", "ruby", "go", "rust",
    "html", "css", "bash", "json", "yaml", "xml", "php", "perl", "swift",
    "kotlin", "r", "dart", "elixir", "erlang", "haskell", "scala", "vim",
    "markdown", "dockerfile", "toml", "graphql", "svelte", "vue", "sql",
    "latex","zig",
  },
  highlight = { enable = true },
  indent = { enable = true },
})

-- LSP Config
local lspconfig = require("lspconfig")
lspconfig.pyright.setup{}
lspconfig.ts_ls.setup{}  -- Updated to ts_ls
lspconfig.rust_analyzer.setup{}
lspconfig.gopls.setup{}
-- Add more LSP servers as needed

-- nvim-cmp Setup for Autocompletion
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }), -- Scroll up in docs
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),  -- Scroll down in docs
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),  -- Trigger autocomplete
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),  -- Close autocomplete menu
      c = cmp.mapping.close(),  -- Close in command mode
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Confirm selection
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),  -- Navigate down in menu
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),  -- Navigate up in menu
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Telescope Keybindings
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fw', builtin.current_buffer_fuzzy_find, { noremap = true, silent = true, desc = "Search within current file" })

-- Undo Tree Keybinding
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true, silent = true }) 

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
--require("alpha").setup(require("alpha.themes.startify").config)

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

