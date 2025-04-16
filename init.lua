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
    { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
    { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
    {
      pane = 2,
      icon = " ",
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
  
  -- Mason (LSP Installer)
  {"williamboman/mason.nvim"},
  {"williamboman/mason-lspconfig.nvim"},

  -- Undo Tree
  {"mbbill/undotree"},

  -- Jupyter nb 
  {
    'goerz/jupytext',
    'goerz/jupytext.vim',
  }
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

-- NOTE: to make any of this work you need a language server.
-- If you don't know what that is, watch this 5 min video:
-- https://www.youtube.com/watch?v=LaS32vctfOY

-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

local lspconfig = require('lspconfig')

-- General
lspconfig.lua_ls.setup({})               -- Lua (useful for Neovim config)
lspconfig.bashls.setup({})               -- Bash
lspconfig.jsonls.setup({})               -- JSON
lspconfig.yamlls.setup({})               -- YAML
lspconfig.html.setup({})                 -- HTML
lspconfig.cssls.setup({})                -- CSS
lspconfig.emmet_ls.setup({})             -- Emmet (HTML/CSS)

-- Web Dev
lspconfig.ts_ls.setup({})             -- TypeScript/JavaScript (corrected from ts_ls)
lspconfig.eslint.setup({})               -- ESLint
lspconfig.svelte.setup({})               -- Svelte
lspconfig.vuels.setup({})                -- Vue
lspconfig.angularls.setup({})            -- Angular
lspconfig.tailwindcss.setup({})          -- Tailwind CSS

-- Python
lspconfig.pyright.setup({})              -- Python (Microsoft)
lspconfig.ruff.setup({})             -- Python (Ruff - linter + fixer) (corrected from ruff)

-- Java
lspconfig.jdtls.setup({})                -- Java

-- C / C++
lspconfig.clangd.setup({})               -- C/C++

-- Rust
lspconfig.rust_analyzer.setup({})        -- Rust

-- Go
lspconfig.gopls.setup({})                -- Go

-- PHP
lspconfig.intelephense.setup({})         -- PHP

-- Ruby
lspconfig.solargraph.setup({})           -- Ruby

-- C#
lspconfig.omnisharp.setup({})            -- C#

-- Dart / Flutter
lspconfig.dartls.setup({})               -- Dart/Flutter

-- Haskell
lspconfig.hls.setup({})                  -- Haskell

-- SQL
lspconfig.sqlls.setup({})                -- SQL

-- Docker
lspconfig.dockerls.setup({})             -- Dockerfile
lspconfig.docker_compose_language_service.setup({}) -- docker-compose

-- Markdown / Writing
lspconfig.marksman.setup({})             -- Markdown
lspconfig.ltex.setup({})                 -- Grammar/spell checking (LaTeX/Markdown)

-- TOML
lspconfig.taplo.setup({})                -- TOML

-- Latex
lspconfig.texlab.setup({})               -- LaTeX

-- Zig
lspconfig.zls.setup({})                  -- Zig

-- CMake
lspconfig.cmake.setup({})                -- CMake

-- Nim
lspconfig.nimls.setup({})                -- Nim

-- Kotlin
lspconfig.kotlin_language_server.setup({}) -- Kotlin

-- Swift
lspconfig.sourcekit.setup({})            -- Swift

-- Assembly (generic)
lspconfig.asm_lsp.setup({})              -- Assembly

-- OCaml & Gleam already included
lspconfig.ocamllsp.setup({})
lspconfig.gleam.setup({})


-- Autocompletion config
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
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

-- ToggleTerm Setup 
require("toggleterm").setup({
  size = 20,                     -- Height of the terminal window
  open_mapping = [[<C-\>]],      -- Keybinding to toggle the terminal
  hide_numbers = true,           -- Hide the line numbers in terminal buffers
  shade_filetypes = {},          -- Filetypes to shade the terminal
  shade_terminals = true,        -- Apply shading to terminal background
  shading_factor = 2,            -- Degree of shading
  start_in_insert = true,        -- Start in insert mode
  insert_mappings = true,        -- Apply keybindings in insert mode
  terminal_mappings = true,      -- Apply keybindings in terminal mode
  persist_size = true,           -- Remember the terminal size
  direction = "horizontal",      -- Set the direction to "horizontal", "vertical", or "float"
  close_on_exit = true,          -- Close the terminal buffer when the process exits
  shell = vim.o.shell,           -- Use the default shell
  float_opts = {                 -- Options for floating terminal
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
})

-- Keybinding to toggle terminal
vim.keymap.set('n', '<C-\\>', ':ToggleTerm<CR>', { noremap = true, silent = true })

-- Optional: Keybindings for opening terminal in different directions
vim.keymap.set('n', '<leader>th', ':ToggleTerm direction=horizontal<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tv', ':ToggleTerm direction=vertical<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<CR>', { noremap = true, silent = true })

-- Gitsigns Setup
require("gitsigns").setup()

-- DAP UI Setup
require("dapui").setup()

-- Auto Pairs Setup
require("nvim-autopairs").setup()

-- Comment.nvim Setup
require("Comment").setup()

-- Project.nvim Setup
require("project_nvim").setup()

-- Which Key Setup
require("which-key").setup()

-- Better Escape Setup
require("better_escape").setup()

-- Neoscroll Setup
require("neoscroll").setup()

-- Colorscheme
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

-- Web Icons Setup
require('nvim-web-devicons').setup({
  default = true;
})

-- Setup Mason for LSP installer
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "pyright",
    "ts_ls",
    "bashls",
    "clangd",
    "rust_analyzer",
    "pylsp"
  },
  automatic_installation = true,
})

