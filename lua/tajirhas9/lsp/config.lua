local on_attach = function(client, bufnr)
    if client.name == 'vtsls' then
        vim.api.nvim_buf_create_user_command(bufnr, 'Prettier', function()
            vim.lsp.buf.format({ bufnr = bufnr })
        end, { desc = 'Format current buffer with LSP' })
    end

    if client.name == 'dartls' then
        vim.api.nvim_buf_create_user_command(bufnr, 'DartFormat', function()
            vim.lsp.buf.format({ bufnr = bufnr })
        end, { desc = 'Format current buffer with LSP' })
    end
    if client:supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
            buffer = bufnr,
            callback = function()
                print("Formatting document on save")
                vim.lsp.buf.format { bufnr = bufnr }
            end,
            desc = '[lsp] format on save',
        })
        -- navic.attach(client, bufnr)
    end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = true,
    lineFoldingOnly = true,
    rangeLimit = 5000
}

return {
    on_attach = on_attach,
    capabilities = capabilities
}
