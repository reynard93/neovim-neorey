-- global vim
local M = {}
local initialized = false

local js_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }

local function chrome_url()
    return vim.fn.input('Vue app URL: ', 'http://localhost:5173')
end

local function setup_keymaps(dap, dapui)
    vim.keymap.set('n', '<leader>5', function() dap.continue() end)
    vim.keymap.set('n', '<leader>6', function() dap.step_over() end)
    vim.keymap.set('n', '<leader>7', function() dap.step_into() end)
    vim.keymap.set('n', '<leader>8', function() dap.step_out() end)
    vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end)
    vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint() end)
    vim.keymap.set('n', '<Leader>lp', function()
        dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end)
    vim.keymap.set('n', '<Leader>dr', function() dap.repl.toggle() end)
    vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
    vim.keymap.set('n', '<Leader>dut', function() dapui.toggle({ reset = true }) end)
    vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
        require('dap.ui.widgets').hover()
    end)
    vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
        require('dap.ui.widgets').preview()
    end)
    vim.keymap.set('n', '<Leader>df', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set('n', '<Leader>ds', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
    end)
    vim.keymap.set('n', '<leader>du', function() dapui.toggle() end)
end

local function setup_js_debugger(dap)
    require('dap-vscode-js').setup({
        debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug',
        adapters = { 'pwa-node', 'pwa-chrome', 'node-terminal' },
    })

    for _, filetype in ipairs(js_filetypes) do
        dap.configurations[filetype] = {
            {
                type = 'pwa-node',
                request = 'launch',
                name = 'Launch current file',
                program = '${file}',
                cwd = '${workspaceFolder}',
                sourceMaps = true,
                skipFiles = { '<node_internals>/**', 'node_modules/**' },
            },
            {
                type = 'pwa-node',
                request = 'attach',
                name = 'Attach to process',
                processId = require('dap.utils').pick_process,
                cwd = '${workspaceFolder}',
                sourceMaps = true,
                skipFiles = { '<node_internals>/**', 'node_modules/**' },
            },
            {
                type = 'pwa-chrome',
                request = 'launch',
                name = 'Launch Chrome for Vue app',
                url = chrome_url,
                webRoot = '${workspaceFolder}',
                sourceMaps = true,
                userDataDir = false,
            },
        }
    end
end

M.setup = function()
    if initialized then
        return
    end
    initialized = true

    local dap = require('dap')
    local dapui = require('dapui')

    dapui.setup()
    require('nvim-dap-virtual-text').setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    setup_keymaps(dap, dapui)
    setup_js_debugger(dap)
end

return M
