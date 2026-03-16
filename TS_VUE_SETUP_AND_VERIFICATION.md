# macOS Setup and Verification for TypeScript, Vue, Oxlint, Flutter, and Debugging

This document covers the files involved in this Neovim setup, the external dependencies you need on a Mac, where each dependency is installed from, and how to verify that the LSP, linter, and DAP layers are working.

## Config files that matter

These are the key files in this repo for the current setup:

- `init.lua`
  - entrypoint
  - loads `lazy.nvim`, core options, and diagnostics
- `lua/tajirhas9/lazy.lua`
  - plugin declarations and plugin-specific setup hooks
  - installs and configures `nvim-oxlint`, `nvim-dap-ui`, `flutter-tools.nvim`, `nvim-treesitter`, and other plugins
- `lua/tajirhas9/mason-config.lua`
  - Mason and Mason LSP setup
  - ensures `lua_ls`, `vtsls`, and `vue_ls`
  - installs LSP keymaps and format-on-save behavior
- `lua/tajirhas9/lsp/vtsls.lua`
  - TypeScript LSP config
  - wires in Vue TypeScript plugin support
- `lua/tajirhas9/lsp/vue_ls.lua`
  - Vue language server config
- `lua/tajirhas9/lsp/config.lua`
  - shared LSP attach behavior and capabilities
- `lua/tajirhas9/lsp/flutter.lua`
  - Flutter tools setup
  - Dart/Flutter DAP adapter and launch configurations
- `lua/tajirhas9/debugger.lua`
  - JavaScript / Vue DAP setup using `vscode-js-debug`
- `lua/tajirhas9/diagnostic.lua`
  - global diagnostics behavior
- `lua/tajirhas9/constants.lua`
  - path helpers plus Flutter/Dart command values

## What gets installed from where

There are three separate installation layers in this setup.

### 1. LSP servers

Installed through:

- `:MasonInstall ...`
- managed by `mason.nvim` and `mason-lspconfig.nvim`

Current LSP servers in this config:

- `lua-language-server`
- `vtsls`
- `vue-language-server`

Installed to:

- `~/.local/share/nvim/mason/packages/`

### 2. DAP / editor plugins

Installed through:

- `:Lazy sync`
- managed by `lazy.nvim`

Important DAP/debug-related plugins:

- `rcarriga/nvim-dap-ui`
- `mfussenegger/nvim-dap`
- `mxsdev/nvim-dap-vscode-js`
- `microsoft/vscode-js-debug`
- `nvim-flutter/flutter-tools.nvim`

Installed to:

- `~/.local/share/nvim/lazy/`

### 3. Oxlint linter binary

Installed per project through npm:

```bash
npm install --save-dev oxlint
```

This setup intentionally runs Oxlint from the project itself via:

```bash
npx oxlint --lsp
```

So Oxlint is installed in the project, not globally.

Installed to:

- `<project>/node_modules/oxlint`

## macOS dependencies to install first

Assume a Mac machine.

### Required base tools

Install Homebrew if not already present:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install required tooling:

```bash
brew install git node
brew install --cask google-chrome
```

Why:

- `git` is required for `lazy.nvim` and repo operations
- `node` / `npm` are required for `vtsls`, `vue-language-server`, project-local `oxlint`, and building `vscode-js-debug`
- Chrome is required for the Vue browser debug flow

### Optional but required for Flutter projects

Install Flutter from the official source:

- https://docs.flutter.dev/get-started/install/macos

You need both Flutter and Dart available.

This config currently uses:

- `flutter` command from `PATH`
- `dart` command from `PATH`

And also has hard-coded Flutter SDK values in `lua/tajirhas9/constants.lua` for one existing environment. If your Mac uses a different SDK location, update that file or keep the commands available in `PATH` so the runtime commands succeed.

## First-time Neovim setup on macOS

From this repo:

```bash
nvim --headless '+qa'
```

This should start cleanly.

Then open Neovim and run:

```vim
:Lazy sync
:MasonInstall lua-language-server vtsls vue-language-server
```

What each command does:

- `:Lazy sync`
  - installs Neovim plugins
  - includes DAP plugins and `vscode-js-debug`
- `:MasonInstall ...`
  - installs LSP servers used by the config

## Confirm startup is clean

From the shell:

```bash
nvim --headless '+qa'
```

Expected result:

- no startup errors

## Minimal TypeScript / Vue / Oxlint test workspace

Create a temporary project:

```bash
mkdir -p /tmp/pi-vue-test/src
cat > /tmp/pi-vue-test/package.json <<'EOF'
{
  "name": "pi-vue-test",
  "private": true,
  "type": "module"
}
EOF

cat > /tmp/pi-vue-test/tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "strict": true,
    "jsx": "preserve"
  },
  "include": ["src/**/*"]
}
EOF

cat > /tmp/pi-vue-test/.oxlintrc.json <<'EOF'
{
  "$schema": "./node_modules/oxlint/configuration_schema.json",
  "categories": {
    "correctness": "warn"
  }
}
EOF

cat > /tmp/pi-vue-test/src/main.ts <<'EOF'
const answer: number = 42
console.log(answer)
EOF

cat > /tmp/pi-vue-test/src/App.vue <<'EOF'
<script setup lang="ts">
const message: string = 'hello'
</script>

<template>
  <div>{{ message }}</div>
</template>
EOF

cd /tmp/pi-vue-test
npm install --save-dev oxlint
```

## Verify TypeScript, Vue, and Oxlint manually

Open the TypeScript file from the project root:

```bash
cd /tmp/pi-vue-test
nvim src/main.ts
```

Inside Neovim:

```vim
:LspInfo
```

Expected result for `main.ts`:

- `vtsls` attached
- `oxc` attached

Then open the Vue file:

```vim
:edit src/App.vue
:LspInfo
```

Expected result for `App.vue`:

- `vtsls` attached
- `vue_ls` attached
- `oxc` attached

Useful checks:

- `K` on `message` shows hover/type info
- `gd` jumps to definition
- `gr` shows references
- `<space>rn` renames a symbol
- diagnostics appear for deliberate type errors

Suggested negative tests:

### TypeScript / Vue type error

Change:

```ts
const message: string = 'hello'
```

To:

```ts
const message: string = 123
```

Expected result:

- Vue/TypeScript diagnostics report the mismatch

### Oxlint warning

Change `src/main.ts` to:

```ts
const unusedValue = 42
```

Save the file.

Expected result:

- `oxc` reports an Oxlint diagnostic

## Verify LSP and Oxlint headlessly

Run this from the test project root:

```bash
cd /tmp/pi-vue-test
nvim --headless src/main.ts \
  '+lua vim.defer_fn(function() local clients=vim.lsp.get_clients({bufnr=0}); print("TS_BUF_CLIENTS="..#clients); for _,c in ipairs(clients) do print("TS_CLIENT="..c.name) end; vim.cmd("edit src/App.vue"); vim.defer_fn(function() local vclients=vim.lsp.get_clients({bufnr=0}); print("VUE_BUF_CLIENTS="..#vclients); for _,c in ipairs(vclients) do print("VUE_CLIENT="..c.name) end; vim.cmd("qa!") end, 3000) end, 3000)'
```

Expected output shape:

```text
OXC LSP started
TS_BUF_CLIENTS=2
TS_CLIENT=oxc
TS_CLIENT=vtsls
VUE_BUF_CLIENTS=3
VUE_CLIENT=oxc
VUE_CLIENT=vtsls
VUE_CLIENT=vue_ls
```

Client order may vary. Presence is what matters.

## Verify Vue debugger configuration exists

From the shell:

```bash
nvim --headless /tmp/pi-vue-test/src/App.vue \
  '+lua vim.defer_fn(function() local dap=require("dap"); print("DAP_HAS_VUE_CONFIGS="..tostring(#(dap.configurations.vue or {}))); print("DAP_HAS_PWA_NODE="..tostring(dap.adapters["pwa-node"] ~= nil)); print("DAP_HAS_PWA_CHROME="..tostring(dap.adapters["pwa-chrome"] ~= nil)); vim.cmd("qa!") end, 1500)'
```

Expected output:

```text
DAP_HAS_VUE_CONFIGS=3
DAP_HAS_PWA_NODE=true
DAP_HAS_PWA_CHROME=true
```

## Verify Vue browser debugging manually

Use a real Vue app. A Vite app on `http://localhost:5173` is the easiest path.

### 1. Start the app

In the Vue project:

```bash
npm install
npm run dev
```

Expected result:

- dev server is available on `http://localhost:5173`

### 2. Open a Vue file and set a breakpoint

Set a breakpoint on an executable line with:

- `<Leader>b`

### 3. Start the debugger

Use:

- `<leader>5`

Choose:

- `Launch Chrome for Vue app`

When prompted, use:

```text
http://localhost:5173
```

Expected result:

- Chrome launches with the debug adapter attached
- execution stops on your breakpoint
- DAP UI opens automatically

### 4. Useful debug keymaps

- `<leader>5` continue
- `<leader>6` step over
- `<leader>7` step into
- `<leader>8` step out
- `<Leader>b` toggle breakpoint
- `<Leader>B` conditional breakpoint
- `<Leader>dr` REPL toggle
- `<leader>du` DAP UI toggle

## Verify Flutter setup is still present

Flutter remains configured in this repo.

### Dependencies for Flutter on macOS

Install Flutter using the official guide:

- https://docs.flutter.dev/get-started/install/macos

Then verify:

```bash
flutter doctor
which flutter
which dart
```

Expected result:

- Flutter SDK installed
- Dart available
- `flutter` and `dart` resolve from your shell

### What this config provides for Flutter

From `lua/tajirhas9/lsp/flutter.lua` and `lua/tajirhas9/constants.lua`:

- `flutter-tools.nvim` setup
- Dart/Flutter DAP adapters
- launch configs for:
  - `Launch dart`
  - `Launch flutter`
- keymaps:
  - `Fr` for Flutter reload
  - `FR` for Flutter restart

### Manual Flutter verification

Open a Flutter project and then inside Neovim:

```vim
:echo executable('flutter')
:echo executable('dart')
```

Expected result:

- both return `1`

Then:

- open a Dart file under a Flutter project
- run `:lua print(vim.inspect(require("dap").configurations.dart))`

Expected result:

- Dart / Flutter DAP launch configurations exist

## What changes for projects that currently use ESLint?

There is no Neovim-side ESLint setup left in this config. The change is project-side.

### If replacing ESLint completely

Do this when Oxlint covers the project's rules.

Recommended steps:

1. install Oxlint:
   ```bash
   npm install --save-dev oxlint
   ```
2. create `.oxlintrc.json` or `oxlint.config.ts`
3. migrate config if needed:
   ```bash
   npx @oxlint/migrate
   ```
4. remove ESLint from scripts and CI once Oxlint is sufficient

### If keeping ESLint for unsupported rules

Do this when the project still depends on custom plugins or rules Oxlint does not cover yet.

Recommended steps:

1. install Oxlint and add `.oxlintrc.json`
2. keep ESLint in CI for remaining unsupported rules
3. use `eslint-plugin-oxlint` in ESLint config to disable overlapping rules

### Cases that still need extra care

- custom in-house ESLint plugins
- parser-heavy ESLint integrations
- `eslint-plugin-prettier`
- rules not yet covered by Oxlint

## Troubleshooting

### If `oxc` does not attach

- confirm you started Neovim from the project root, or that the file belongs to a project containing `package.json` or `.oxlintrc.json`
- confirm the project has `.oxlintrc.json` or `oxlintrc.json`
- confirm the project has `oxlint` installed
- run:
  ```bash
  npx oxlint --lsp
  ```
  from the project root to verify the binary is available
- check `:LspInfo`

### If `vtsls` or `vue_ls` does not attach

- run `:Mason`
- confirm both packages are installed
- check `:LspInfo`
- confirm the project root contains `package.json` and `tsconfig.json`
- verify `node` is available in `PATH`

### If Vue breakpoints do not bind

- make sure the app serves source maps
- prefer Vite dev mode for testing
- ensure Neovim is opened at the project root
- confirm the URL matches the running app exactly

### If Flutter debug sessions do not start

- run `flutter doctor`
- confirm `flutter` and `dart` are available in `PATH`
- verify the SDK paths in `lua/tajirhas9/constants.lua` if your machine does not match the original author's paths

## Source-backed references

- nvim-oxlint: https://github.com/soulsam480/nvim-oxlint
- Oxlint config docs: https://oxc.rs/docs/guide/usage/linter/config
- Oxlint migration guide: https://oxc.rs/docs/guide/usage/linter/migrate-from-eslint
- eslint-plugin-oxlint: https://github.com/oxc-project/eslint-plugin-oxlint
- Flutter macOS install guide: https://docs.flutter.dev/get-started/install/macos
