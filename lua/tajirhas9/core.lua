vim.wo.number = true         -- Show line numbers
vim.wo.relativenumber = true -- Show relative line number
vim.cmd [[set mouse=a]]      -- Mouse active
vim.o.tabstop = 4            -- A TAB character looks like 4 spaces
vim.o.expandtab = true       -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4        -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4         -- Number of spaces inserted when indenting

if vim.fn.has('nvim-0.12') == 1 then
    vim.o.diffopt = 'internal,filler,closeoff,inline:word,linematch:40'
elseif vim.fn.has('nvim-0.11') == 1 then
    vim.o.diffopt = 'internal,filler,closeoff,linematch:40'
end

vim.keymap.set('n', '<leader>gg', function()
    vim.cmd('LazyGit')
end)
local map = vim.api.nvim_set_keymap

map('n', '<leader>e', [[:Neotree toggle<CR>]], {})

-- jump to older cursor position
map('n', '<M-Left>', '<C-o>', { noremap = true, silent = true })


-- jump to newer cursor position
map('n', '<M-Right>', '<C-i>', { noremap = true, silent = true })


-- cursor to center when scrolling
map('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
map('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })
-- map('n', '<C-[>', '<CMD>BufferLineCyclePrev<CR>', { noremap = true, silent = true })
-- map('n', '<C-]>', '<CMD>BufferLineCycleNext<CR>', { noremap = true, silent = true })
map('n', '<Esc>', '<CMD><CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
vim.opt.clipboard:append("unnamedplus")

-- Delete shared directory temp files if present
vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    group = vim.api.nvim_create_augroup('fuck_shada_temp', { clear = true }),
    pattern = { '*' },
    callback = function()
        local status = 0
        for _, f in ipairs(vim.fn.globpath(vim.fn.stdpath('data') .. '/shada', '*tmp*', false, true)) do
            if vim.tbl_isempty(vim.fn.readfile(f)) then
                status = status + vim.fn.delete(f)
            end
        end
        if status ~= 0 then
            vim.notify('Could not delete empty temporary ShaDa files.', vim.log.levels.ERROR)
            vim.fn.getchar()
        end
    end,
    desc = "Delete empty temp ShaDa files"
})
