vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Bootstrap lazy.nvim
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

require('lazy').setup({
    {'tpope/vim-fugitive'},
    {'tpope/vim-rhubarb'},
    {'nvim-lua/plenary.nvim'},
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = {'nvim-lua/plenary.nvim'}
    },
    -- {
    --   'junegunn/fzf.vim',
    --   requires = {'junegunn/fzf', run = ':call fzf#install()'}
    -- },
    -- Translate other plugins similarly...
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },

    {'tjdevries/cyclist.vim'},

    -- Pretty colors
    {
      "norcalli/nvim-terminal.lua",
      config = function()
        require("terminal").setup()
      end,
    },
    {'peterhoeg/vim-qml'},
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {'ThePrimeagen/vim-be-good'},

    -- git stuff
    {"petertriho/cmp-git"},
    {'ThePrimeagen/git-worktree.nvim'},
    {'ThePrimeagen/harpoon'},
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    },
    {'stsewd/fzf-checkout.vim'},

    {
      'glacambre/firenvim',

      -- Lazy load firenvim
      -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
      lazy = not vim.g.started_by_firenvim,
      build = function()
          vim.fn["firenvim#install"](0)
      end
    },

    {'williamboman/nvim-lsp-installer'},
    -- Useful status updates for LSP
    {'j-hui/fidget.nvim', tag = 'legacy'},
    {
        -- Additional lua configuration, makes nvim stuff amazing
        'folke/neodev.nvim',
        'VonHeikemen/lsp-zero.nvim',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        -- LSP Support
        {'neovim/nvim-lspconfig'},
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'saadparwaiz1/cmp_luasnip'},
        {'hrsh7th/cmp-nvim-lua'},

        -- Snippets
        {'L3MON4D3/LuaSnip'},
        {'rafamadriz/friendly-snippets'},
    },

    {'rust-lang/rust.vim'},
    -- Completion
    {'hrsh7th/cmp-cmdline'},
    {'onsails/lspkind-nvim'},
    {'nvim-lua/lsp_extensions.nvim'},

    {'hrsh7th/cmp-nvim-lsp-document-symbol'},

    { 'codota/tabnine-nvim', build = "./dl_binaries.sh" },

    {
      'tzachar/cmp-tabnine',
      build = './install.sh',
      dependencies = 'hrsh7th/nvim-cmp',
    },
    {'rhysd/vim-clang-format'},
    {'mbbill/undotree'},
    {'nvim-tree/nvim-web-devicons'},
    { 'nvim-treesitter/nvim-treesitter', build = ":TSUpdate"},

    { -- Additional text objects via treesitter
        'nvim-treesitter/nvim-treesitter-textobjects',
    },

    {'nvim-treesitter/playground'},
    {'romgrk/nvim-treesitter-context'},
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = "cd app && yarn install",
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" },
    },
    { "folke/zen-mode.nvim" },
    {'numToStr/Comment.nvim'}, -- "gc" to comment visual regions/lines
    {'tpope/vim-sleuth'}, -- Detect tabstop and shiftwidth automatically
    {
      "dhananjaylatkar/cscope_maps.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
        "ibhagwan/fzf-lua", -- optional [for picker="fzf-lua"]
        "nvim-tree/nvim-web-devicons", -- optional [for devicons in telescope or fzf]
      },
      opts = {
        -- USE EMPTY FOR DEFAULT OPTIONS
        -- DEFAULTS ARE LISTED BELOW
      },
    },
    {'eandrju/cellular-automaton.nvim'},
    {
      'nvimdev/lspsaga.nvim',
      config = function()
          require('lspsaga').setup({})
      end,
      dependencies = {
          'nvim-treesitter/nvim-treesitter', -- optional
          'nvim-tree/nvim-web-devicons',     -- optional
      }
    },

    {'rcarriga/nvim-notify'}, -- Notify popup
    {"Cassin01/wf.nvim", version = "*", config = function() require("wf").setup() end},
    {'mfussenegger/nvim-lint'},
    {'fatih/vim-go'},
    { "stevearc/oil.nvim" },
})

