-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
end

local function tabnine_build_path()
  if vim.loop.os_uname().sysname == "Windows_NT" then
    return "pwsh.exe -file .\\dl_binaries.ps1"
  else
    return "./dl_binaries.sh"
  end
end

local packages = require('packer').startup(function()
-- return require('packer').startup(function()
    use {'wbthomason/packer.nvim'}

    -- Simple plugins can be specified as strings
    -- use {'TimUntersberger/neogit'}
    -- use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
    use {'tpope/vim-fugitive'}
    use {'tpope/vim-rhubarb'}

    -- TJ created lodash of neovim
    use {'nvim-lua/plenary.nvim'}
    -- Fuzzy Finder (files, lsp, etc)
    use { 'nvim-telescope/telescope.nvim',
        branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' }
    }

    use {
        'junegunn/fzf.vim',
        requires = { 'junegunn/fzf', run = ':call fzf#install()' }
     }

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

    use {'tjdevries/cyclist.vim'}

    -- Pretty colors
    use {
      "norcalli/nvim-terminal.lua",
      config = function()
        require("terminal").setup()
      end,
    }
    use {'peterhoeg/vim-qml'}
    use { "catppuccin/nvim", as = "catppuccin" }
    use {'ThePrimeagen/vim-be-good'}

    -- git stuff
    use({"petertriho/cmp-git", requires = "nvim-lua/plenary.nvim"})
    use {'ThePrimeagen/git-worktree.nvim'}
    use {'ThePrimeagen/harpoon'}
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }
    use {'stsewd/fzf-checkout.vim'}

    use {
        'glacambre/firenvim',
        run = function() vim.fn['firenvim#install'](0) end
    }

    use {'williamboman/nvim-lsp-installer'}
    -- Useful status updates for LSP
    use {'j-hui/fidget.nvim', tag = 'legacy'}
    use {
        -- Additional lua configuration, makes nvim stuff amazing
        'folke/neodev.nvim',
        'VonHeikemen/lsp-zero.nvim',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    use {'rust-lang/rust.vim'}
    -- Completion
    use {'hrsh7th/cmp-cmdline'}
    use {'onsails/lspkind-nvim'}
    use {'nvim-lua/lsp_extensions.nvim'}

    use {'hrsh7th/cmp-nvim-lsp-document-symbol'}

    use { 'codota/tabnine-nvim', run = tabnine_build_path() }

    use {
        'tzachar/cmp-tabnine',
        run='./install.sh',
        requires = 'hrsh7th/nvim-cmp'
    }
    use {'rhysd/vim-clang-format'}

    use {'mbbill/undotree'}

    -- use {'ryanoasis/vim-devicons'}
    use {'nvim-tree/nvim-web-devicons'}

    use { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }

    use { -- Additional text objects via treesitter
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    }

    use {'nvim-treesitter/playground'}
    use {'romgrk/nvim-treesitter-context'}

    use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

    use {
      "folke/zen-mode.nvim",
      config = function()
        require("zen-mode").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }

    use {'numToStr/Comment.nvim'} -- "gc" to comment visual regions/lines
    use {'tpope/vim-sleuth'} -- Detect tabstop and shiftwidth automatically
    -- use { 'nvim-lualine/lualine.nvim',  -- Fancier statusline
    --        require = { 'nvim-tree/nvim-web-devicons', opt = true } }

    use {'dhananjaylatkar/cscope_maps.nvim'} -- cscope keymaps

    use {'eandrju/cellular-automaton.nvim'}

    use ({
        'nvimdev/lspsaga.nvim',
        after = 'nvim-lspconfig',
        config = function()
            require('lspsaga').setup({})
        end,
    })

    use {'rcarriga/nvim-notify'} -- Notify popup

    use { "Cassin01/wf.nvim", config = function() require("wf").setup() end }
    use {'mfussenegger/nvim-lint'}

    use {'fatih/vim-go'}

    if is_bootstrap then
        require('packer').sync()
    end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
    print '=================================='
    print '    Plugins are being installed'
    print '    Wait until Packer completes,'
    print '       then restart nvim'
    print '=================================='
    return
end

return packages
