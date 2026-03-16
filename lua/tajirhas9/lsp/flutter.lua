local M = {}
local initialized = false

M.setup = function()
    if initialized then
        return
    end
    initialized = true

    local constants = require("tajirhas9.constants")
    local on_attach = require('tajirhas9.lsp.config').on_attach
    local capabilities = require('tajirhas9.lsp.config').capabilities
    local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
    local dap = require('dap')

    require("flutter-tools").setup {
        debugger = {
            enabled = true,
            register_configurations = function(_)
                dap.configurations.dart = {
                    {
                        type = "dart",
                        request = "launch",
                        name = "Launch dart",
                        dartSdkPath = constants.DART_SDK_PATH,
                        flutterSdkPath = constants.FLUTTER_SDK_PATH,
                        program = "${workspaceFolder}/lib/main.dart",
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "flutter",
                        request = "launch",
                        name = "Launch flutter",
                        dartSdkPath = constants.DART_SDK_PATH,
                        flutterSdkPath = constants.FLUTTER_SDK_PATH,
                        program = "${workspaceFolder}/lib/main.dart",
                        cwd = "${workspaceFolder}",
                    }
                }

                dap.adapters.dart = {
                    type = 'executable',
                    command = constants.DART_COMMAND,
                    args = { 'debug_adapter' },
                    options = {
                        detached = not is_windows,
                    }
                }
                dap.adapters.flutter = {
                    type = 'executable',
                    command = constants.FLUTTER_COMMAND,
                    args = { 'debug_adapter' },
                    options = {
                        detached = not is_windows,
                    }
                }
            end,
            flutter_path = constants.FLUTTER_SDK_PATH,
            dev_log = {
                enabled = false
            },
            dev_tools = {
                autostart = true,
                auto_openbrowser = true
            }
        },
        on_attach = on_attach,
        capabilities = capabilities
    }

    vim.keymap.set('n', 'Fr', [[:FlutterReload<CR>]], {})
    vim.keymap.set('n', 'FR', [[:FlutterRestart<CR>]], {})
end

return M
