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

require("lazy").setup({
    {
        "neovim/nvim-lspconfig",
        event = { 'BufRead', 'BufNew' },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        }
    },
    { "hrsh7th/nvim-cmp",                    event = "InsertEnter" },
    { "hrsh7th/cmp-nvim-lsp",                event = "InsertEnter" },
    { "hrsh7th/cmp-nvim-lsp-signature-help", event = "InsertEnter" },
    { "hrsh7th/cmp-path",                    event = "InsertEnter" },
    { "hrsh7th/cmp-buffer",                  event = "InsertEnter" },
    {
        "nvim-neo-tree/neo-tree.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    },
    "nvim-lualine/lualine.nvim",
    {
        "nvim-treesitter/nvim-treesitter", --, build = ":TSUpdate"
        event = { 'BufRead', 'BufNew' }
    },
    {
        "ibhagwan/fzf-lua",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equalent to setup({}) function
    },
    -- { 'akinsho/bufferline.nvim', version = "*",     dependencies = 'nvim-tree/nvim-web-devicons' },
    -- { 'yamatsum/nvim-cursorline' },
    {
        'numToStr/Comment.nvim',
        event = { 'BufRead', 'BufNew' },
        opts = {
            -- add any options here
        },
    },
    { "lewis6991/gitsigns.nvim", event = 'VeryLazy' },
    { "tpope/vim-fugitive",      event = "VeryLazy" },
    --######################
    -- Themes
    -- { 'projekt0n/github-nvim-theme' },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    -- { "EdenEast/nightfox.nvim",     priority = 1000, config = true, opts = {} },
    -- { "ellisonleao/gruvbox.nvim", priority = 1000,   config = true,                               opts = ... },
    -- {
    --     "navarasu/onedark.nvim",
    --     dependencies = {
    --         'nvim-tree/nvim-web-devicons'
    --     }
    -- },
    --#######################
    { "sindrets/diffview.nvim",                  event = "VeryLazy" },
    {
        "tajirhas9/nvim-colorizer.lua",
        event = { 'BufRead', 'BufNew' },
    },
    {
        "kkoomen/vim-doge",
        event = "VeryLazy",
    },
    {
        "Exafunction/windsurf.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        event = "InsertEnter",
    },
    -- {
    --     "github/copilot.vim",
    --     event = "InsertEnter",
    -- },
    {
        "mbbill/undotree",
        event = { 'BufRead', 'BufNew' }
    },

    -- Show current code context
    {
        "SmiteshP/nvim-navic",
        event = { 'BufRead', 'BufNew' },
        dependencies = {
            "neovim/nvim-lspconfig"
        }
    },
    { "nvim-treesitter/nvim-treesitter-context", event = "VeryLazy" },
    {
        "kevinhwang91/nvim-ufo",
        event = "VeryLazy",
        dependencies = {
            "kevinhwang91/promise-async"
        }
    },
    -- flutter
    {
        'nvim-flutter/flutter-tools.nvim',
        event = { 'BufRead', 'BufNew' },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
        config = true,
    },
    -- DAP
    {
        "rcarriga/nvim-dap-ui",
        event = { 'BufRead', 'BufNew' },
        config = true,
        dependencies = {
            "jay-babu/mason-nvim-dap.nvim",
            "leoluz/nvim-dap-go",
            "mfussenegger/nvim-dap-python",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
        },
    },
    {
        "vuki656/package-info.nvim",
        event = { 'BufRead', 'BufNew' }
    }
})
