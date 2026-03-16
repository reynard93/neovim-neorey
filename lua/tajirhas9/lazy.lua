local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
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
        },
        config = function()
            require("tajirhas9.mason-config").setup()
        end,
    },
    {
        "soulsam480/nvim-oxlint",
        event = { 'BufRead', 'BufNew' },
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = function()
            local oxlint = require("nvim-oxlint")
            oxlint.resolve_git_dir = function(bufnr)
                return vim.fs.root(bufnr, { '.git', 'package.json', '.oxlintrc.json', 'oxlintrc.json' })
                    or vim.fn.getcwd()
            end
            oxlint.setup({
                run = 'onSave',
                config_path = '.oxlintrc.json',
                enable = true,
                bin_path = { 'npx', 'oxlint', '--lsp' },
                type_aware = true,
                filetypes = {
                    'javascript',
                    'javascriptreact',
                    'javascript.jsx',
                    'typescript',
                    'typescriptreact',
                    'typescript.tsx',
                    'vue',
                },
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
        },
        config = function()
            require("tajirhas9.code-completion").setup()
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("tajirhas9.file-explorer")
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "folke/tokyonight.nvim",
        },
        config = function()
            require("tajirhas9.styling")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context",
            {
                "kevinhwang91/nvim-ufo",
                dependencies = {
                    "kevinhwang91/promise-async",
                },
            },
        },
        config = function()
            require("tajirhas9.syntax-highlighting").setup()
        end,
    },
    {
        "ibhagwan/fzf-lua",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("tajirhas9.file-finder")
        end,
    },
    {
        'windwp/nvim-autopairs',
        lazy = false,
        opts = {
            disable_filetype = { "TelescopePrompt", "vim" },
        },
    },
    {
        'numToStr/Comment.nvim',
        event = { 'BufRead', 'BufNew' },
        opts = {},
    },
    {
        "lewis6991/gitsigns.nvim",
        event = 'VeryLazy',
        config = function()
            require("tajirhas9.git").setup()
        end,
    },
    { "tpope/vim-fugitive", event = "VeryLazy" },
    { "sindrets/diffview.nvim", event = "VeryLazy" },
    {
        "tajirhas9/nvim-colorizer.lua",
        event = { 'BufRead', 'BufNew' },
        config = function()
            require("colorizer").setup({ '*' })
        end,
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
    {
        "github/copilot.vim",
        event = "InsertEnter",
        init = function()
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_assume_mapped = true
            vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false,
                silent = true,
                desc = 'Copilot accept suggestion',
            })
            vim.keymap.set('i', '<M-]>', '<Plug>(copilot-next)', { silent = true, desc = 'Copilot next suggestion' })
            vim.keymap.set('i', '<M-[>', '<Plug>(copilot-previous)', { silent = true, desc = 'Copilot previous suggestion' })
            vim.keymap.set('i', '<C-]>', '<Plug>(copilot-dismiss)', { silent = true, desc = 'Copilot dismiss suggestion' })
        end,
    },

    {
        "mbbill/undotree",
        event = { 'BufRead', 'BufNew' }
    },
    {
        "SmiteshP/nvim-navic",
        event = { 'BufRead', 'BufNew' },
        dependencies = {
            "neovim/nvim-lspconfig"
        }
    },
    {
        'nvim-flutter/flutter-tools.nvim',
        event = { 'BufRead', 'BufNew' },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim',
        },
        config = function()
            require('tajirhas9.lsp.flutter').setup()
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        event = { 'BufRead', 'BufNew' },
        config = function()
            require("tajirhas9.debugger").setup()
        end,
        dependencies = {
            "jay-babu/mason-nvim-dap.nvim",
            "leoluz/nvim-dap-go",
            "mfussenegger/nvim-dap-python",
            "mfussenegger/nvim-dap",
            "mxsdev/nvim-dap-vscode-js",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
            {
                "microsoft/vscode-js-debug",
                version = "1.x",
                build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
            },
        },
    },
    {
        "vuki656/package-info.nvim",
        event = { 'BufRead', 'BufNew' },
        config = function()
            require('package-info').setup({})
        end,
    }
})
