# Copilot Setup

This repo now includes `github/copilot.vim` in a minimal setup.

## What it provides

- inline GitHub Copilot suggestions in insert mode
- suggestion cycling and dismiss actions
- `:Copilot setup` authentication flow

## What it does not provide

`copilot.vim` does not provide the full VS Code Copilot Chat experience by itself.

It gives inline completions, not the full chat UI/workflow from VS Code. If you want GitHub-native chat inside Neovim later, that is a separate plugin decision.

## Dependencies

On macOS, install:

```bash
brew install node git
```

You also need an active GitHub Copilot subscription or Copilot Free enabled on your GitHub account.

## Install plugin files

The plugin is installed by `lazy.nvim` into:

- `~/.local/share/nvim/lazy/copilot.vim`

Run:

```vim
:Lazy sync
```

## Authenticate

Inside Neovim, run:

```vim
:Copilot setup
```

Follow the browser/device login flow.

## Keybindings in this repo

These mappings were chosen to avoid conflicts with existing `nvim-cmp` mappings.

Insert mode:

- `<C-J>` accept Copilot suggestion
- `<M-]>` next Copilot suggestion
- `<M-[>` previous Copilot suggestion
- `<C-]>` dismiss Copilot suggestion

## Why Tab is not used

This repo already uses `nvim-cmp` mappings:

- `<Tab>` next completion item
- `<S-Tab>` previous completion item

So Copilot's default Tab accept mapping is disabled on purpose.

## Relevant config file

- `lua/tajirhas9/lazy.lua`
  - plugin declaration and Copilot keymaps

## Notes about existing AI plugins

- `windsurf.nvim` is still present in the repo
- the stale `codeium` cmp source was removed to avoid a dead/ambiguous AI completion source

## Quick verification

Start Neovim and check:

```vim
:echo exists(':Copilot')
```

Expected result:

- `2`

Then open a code file, enter insert mode, and confirm:

- inline Copilot ghost text appears after authentication
- `<C-J>` accepts it
- `<Tab>` still controls `nvim-cmp`, not Copilot
