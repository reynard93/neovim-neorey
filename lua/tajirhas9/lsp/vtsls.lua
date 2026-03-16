local on_attach = require('tajirhas9.lsp.config').on_attach
local capabilities = require('tajirhas9.lsp.config').capabilities
local join_path = require('tajirhas9.constants').join_path

local vue_language_server_path = vim.fn.stdpath 'data' ..
    join_path('mason', 'packages', 'vue-language-server', 'node_modules', '@vue', 'language-server')
local tsserver_filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' }
local vue_plugin = {
    name = '@vue/typescript-plugin',
    location = vue_language_server_path,
    languages = { 'vue' },
    configNamespace = 'typescript',
    enableForWorkspaceTypeScriptVersions = true,
}

local vtsls_config = {
    on_attach = function(client, bufnr)
        local semantic_tokens = client.server_capabilities.semanticTokensProvider
        if semantic_tokens then
            semantic_tokens.full = vim.bo[bufnr].filetype ~= 'vue'
        end
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
        completions = {
            completeFunctionCalls = true
        },
        vtsls = {
            tsserver = {
                globalPlugins = {
                    vue_plugin,
                },
            },
        },
    },
    filetypes = tsserver_filetypes,
}

vim.lsp.config('vtsls', vtsls_config)
vim.lsp.enable('vtsls')