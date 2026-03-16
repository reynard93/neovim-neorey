# Finder Keybindings Cheatsheet

## Leader key

- `mapleader`: `<Space>`
  - Source: `lua/tajirhas9/core.lua:16`
- `maplocalleader`: not explicitly set anywhere in this config

## Which finder plugin is active?

This config currently uses `ibhagwan/fzf-lua`, not Telescope.

- Plugin load: `lua/tajirhas9/lazy.lua:109-114`
- Finder keymaps: `lua/tajirhas9/file-finder.lua`
- LSP symbol picker keymaps: `lua/tajirhas9/mason-config.lua`

There are old Telescope examples left commented out in `lua/tajirhas9/file-finder.lua`, but the active mappings call `fzf-lua`.

## Global finder bindings

All of these are normal-mode mappings.

| Keys | Expands to | Action | Source |
|---|---|---|---|
| `<leader>ff` | `<Space>ff` | Find files | `lua/tajirhas9/file-finder.lua:37` |
| `<leader>fg` | `<Space>fg` | Live grep / ripgrep search | `lua/tajirhas9/file-finder.lua:38` |
| `<leader>fm` | `<Space>fm` | Show marks | `lua/tajirhas9/file-finder.lua:39` |
| `<leader>;` | `<Space>;` | List open buffers | `lua/tajirhas9/file-finder.lua:40` |
| `<leader>fo` | `<Space>fo` | Recent files / oldfiles | `lua/tajirhas9/file-finder.lua:41` |
| `<leader>fs` | `<Space>fs` | Treesitter symbols | `lua/tajirhas9/file-finder.lua:42` |
| `<leader>fh` | `<Space>fh` | Help tags | `lua/tajirhas9/file-finder.lua:43` |

## LSP-related picker bindings

These mappings are buffer-local and only exist after an LSP attaches.

| Keys | Expands to | Action | Source |
|---|---|---|---|
| `<leader>ds` | `<Space>ds` | Document symbols via picker | `lua/tajirhas9/mason-config.lua:37` |
| `<leader>ws` | `<Space>ws` | Workspace symbols via picker | `lua/tajirhas9/mason-config.lua:38` |

## Inside the fzf UI

These are internal `fzf-lua` picker keybindings configured in the picker UI itself:

| Keys | Action | Source |
|---|---|---|
| `Tab` | Move selection down | `lua/tajirhas9/file-finder.lua:31` |
| `Shift-Tab` | Move selection up | `lua/tajirhas9/file-finder.lua:32` |

## Telescope notes

Commented-out Telescope examples exist for:

- `<leader>ff` -> `telescope.builtin.find_files()`
- `<leader>fg` -> `telescope.builtin.live_grep()`
- `<leader>;` -> `telescope.builtin.buffers()`
- `<leader>fo` -> `telescope.builtin.oldfiles()`
- `<leader>fb` -> `telescope.builtin.find_files({ cwd = require"telescope.utils".buffer_dir() })`

Those are comments only, not active mappings.
