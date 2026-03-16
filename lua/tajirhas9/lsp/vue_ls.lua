local on_attach = require('tajirhas9.lsp.config').on_attach
local capabilities = require('tajirhas9.lsp.config').capabilities

local vue_ls_config = {
    on_attach = on_attach,
    capabilities = capabilities,
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