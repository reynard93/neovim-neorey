-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
local colors = {
    blue   = '#80a0ff',
    cyan   = '#79dac8',
    black  = '#080808',
    white  = '#c6c6c6',
    red    = '#ff5189',
    violet = '#d183e8',
    grey   = '#303030',
}

local bubbles_theme = {
    normal = {
        a = { fg = colors.black, bg = colors.violet },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.white },
    },

    insert = { a = { fg = colors.black, bg = colors.blue } },
    visual = { a = { fg = colors.black, bg = colors.cyan } },
    replace = { a = { fg = colors.black, bg = colors.red } },

    inactive = {
        a = { fg = colors.white, bg = colors.black },
        b = { fg = colors.white, bg = colors.black },
        c = { fg = colors.white },
    },
}

-- ######################
-- Themes

-- Github
-- vim.cmd('colorscheme github_dark_dimmed')
-- vim.o.background = "dark" -- or "light" for light mode


-- gruvbox
-- vim.cmd([[colorscheme gruvbox]])



-- nightfox
-- require('nightfox').setup({
--     options = {
--         styles = {
--             comments = "italic",
--             keywords = "bold",
--             types = "italic,bold",
--         }
--     }
-- })
-- vim.cmd([[colorscheme nightfox]])



-- tokyonight
require('tokyonight').setup({
    style = 'night',
    on_colors = function(_colors)
        -- _colors.bg = '#262626'
        _colors.bg = '#1d2021'
    end
})
vim.cmd([[colorscheme tokyonight]])
-- require("onedark").setup({
--     style = 'warm',
--     lualine = {
--         transparent = false,
--     },
-- })
--
-- ######################
--
--
--

local clients_lsp = function()
    -- local bufnr = vim.api.nvim_get_current_buf()

    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
        return ''
    end

    local c = {}
    for _, client in pairs(clients) do
        table.insert(c, client.name)
    end
    return '\u{f085} ' .. table.concat(c, '|')
end

require("lualine").setup({
    options = {
        theme = bubbles_theme,
        component_separators = '',
        section_separators = { left = '', right = '' },
        always_show_tabline = true,
    },
    sections = {
        lualine_a = { { 'mode', icons_enabled = true, separator = { left = '' }, right_padding = 2 } },
        lualine_b = { { 'filename', path = 1 }, 'branch' },
        lualine_c = {
            { clients_lsp }
        },
        lualine_x = { 'filetype', 'progress' },
    },
    inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
    },
    tabline = {
        lualine_a = { { 'buffers', mode = 4, color = { fg = colors.white, bg = colors.black }, separator = { right = '' } } },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'branch' },
        lualine_z = { 'buffer' }
    },
    inactive_tabline = {
        lualine_a = { 'buffers', mode = 4 },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {}
    },
    extensions = {},
})


vim.cmd [[highlight LineNr guifg=#6e7681]] -- Mouse active
