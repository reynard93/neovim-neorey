local M = {}
local initialized = false

local function open_focused_diagnostic()
    vim.api.nvim_command('set eventignore=WinLeave')
    vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
    vim.diagnostic.open_float(nil, {
        focusable = true,
        scope = 'line',
        close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" },
    })
end

function M.setup()
    if initialized then
        return
    end
    initialized = true

    vim.o.updatetime = 300
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = true,
        float = {
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = vim.api.nvim_create_augroup("DiagnosticHoverManagement", { clear = true }),
        callback = function()
            -- Intentionally left blank so diagnostics are shown only on demand.
        end,
    })

    vim.keymap.set('n', '<leader>dd', open_focused_diagnostic, { silent = true })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "json",
        group = vim.api.nvim_create_augroup("PackageJsonKeymaps", { clear = true }),
        callback = function()
            if vim.fn.expand("%:t") ~= "package.json" then
                return
            end

            local bufnr = vim.api.nvim_get_current_buf()
            vim.keymap.set("n", "<leader>pu", require("package-info").update, {
                buffer = bufnr,
                desc = "Update package on line",
                silent = true,
                noremap = true,
            })
        end,
    })
end

M.setup()

return M
