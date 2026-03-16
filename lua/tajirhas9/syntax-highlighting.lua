local M = {}
M.setup = function()
    require 'nvim-treesitter.install'.prefer_git = false
    if vim.loop.os_uname().sysname == "Windows_NT" then
        require('nvim-treesitter.install').compilers = { "gcc", "clang" }
    end

    require('nvim-treesitter').setup({
        ensure_installed = { "css", "html", "javascript", "json", "lua", "tsx", "typescript", "vue" },
        sync_install = true,
        auto_install = true,
        highlight = {
            enable = true,
        },
        folding = {
            enable = true,
            disable = { 'vue' }, -- Add filetypes here if you want to disable folding for specific languages
        }
    })

    require 'treesitter-context'.setup {
        enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
        multiwindow = false,      -- Enable multiwindow support.
        max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20,     -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    }

    vim.cmd [[hi TreesitterContextBottom gui=underline guisp=Grey]]

    vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
    end, { silent = true })

    -- Custom fold expression function
    function CustomFoldExpr()
        local lnum = vim.v.lnum           -- Current line number
        local line = vim.fn.getline(lnum) -- Get the current line's content

        -- Check for #region and #endregion
        if line:find("// #region") then
            return ">1" -- Start a new fold level
        elseif line:find("// #endregion") then
            return "<1" -- End the fold level
        end
        -- Fallback to nvim-ufo's folding provider
        return vim.fn['nvim_treesitter#foldexpr']()
    end

    vim.o.foldcolumn = '1' -- '0' is not bad
    vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.foldmethod = 'expr'
    vim.o.foldexpr = 'v:lua.CustomFoldExpr()'

    require 'ufo'.setup {
        provider_selector = function(bufnr, filetype, buftype)
            return { 'lsp', 'indent' }
        end
    }

    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
    vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)
    vim.keymap.set('n', 'zK', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
            vim.lsp.buf.hover()
        end
    end)
end
return M