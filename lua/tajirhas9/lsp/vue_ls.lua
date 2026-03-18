local on_attach = require('tajirhas9.lsp.config').on_attach
local capabilities = require('tajirhas9.lsp.config').capabilities

local vue_ls_config = {
    on_attach = on_attach,
    capabilities = capabilities,
    -- Critical: Forward tsserver requests to vtsls for hybrid mode
    on_init = function(client)
        client.handlers['tsserver/request'] = function(_, result, context)
            local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
            if #vtsls_clients == 0 then
                vim.notify('Could not find `vtsls` lsp client required by `vue_ls`.', vim.log.levels.ERROR)
                return
            end
            local vtsls_client = vtsls_clients[1]
            local param = unpack(result)
            local id, command, payload = unpack(param)
            vtsls_client:exec_cmd({
                title = 'vue_request_forward',
                command = 'typescript.tsserverRequest',
                arguments = { command, payload },
            }, { bufnr = context.bufnr }, function(_, r)
                local response = r and r.body
                local response_data = { { id, response } }
                client:notify('tsserver/response', response_data)
            end)
        end
    end,
    settings = {
        vue = {
            codeLens = {
                references = true,
                pugReferences = true,
                scriptSetupSupport = true,
            },
        },
    },
}

vim.lsp.config('vue_ls', vue_ls_config)
vim.lsp.enable('vue_ls')
