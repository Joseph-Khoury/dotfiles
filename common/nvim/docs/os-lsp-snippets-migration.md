# Neovim OS / LSP / Snippets migration notes

This change-set is scoped to portability, LSP correctness, diagnostics, completion, and LaTeX snippets. It deliberately avoids changing the visual workflow more than necessary.

## Added

- `lua/utils/os.lua`: central OS detection and shared helpers for macOS, WSL, and normal Linux.
- `luasnippets/tex.lua`: LuaSnip-based LaTeX snippets, seeded from the high-value static and regex portions of the Obsidian `Snippets.js` file.
- `telescope-ui-select.nvim`: makes `vim.ui.select()` flows, including code actions, use Telescope-style selection.
- `cmp-buffer`, `cmp-path`, `cmp-vimtex`: these were configured as completion sources before, but the plugins were not installed.
- `trouble.nvim`: optional diagnostics panel.

## Rewritten

- `lua/plugins/language/lsp.lua`: moved to Neovim 0.12-style `vim.lsp.config()` with Mason's automatic enable flow.
- `lua/config/diagnostics.lua`: moved to modern `vim.diagnostic.config()` sign configuration.
- `lua/plugins/completion/cmp.lua`: adds snippet placeholder jumping, bordered UI, source labels, VimTeX completion, and custom LuaSnip loading.
- `lua/plugins/writing/vimtex.lua`: makes PDF viewing OS-aware and lets VimTeX provide LaTeX syntax/math-zone detection.
- `lua/plugins/core/treesitter.lua`: adds Verilog and VHDL parsers.

## Deliberately not fully migrated yet

The Obsidian `Snippets.js` file contains advanced JavaScript callback snippets and macro references such as `${GREEK}` / `${SYMBOL}`. Those should be ported manually in stages after the base LuaSnip setup is validated. The new `luasnippets/tex.lua` ports a safe, high-value subset first so that typing performance and expansion behaviour remain supervised.

## Validation checklist

1. `nvim --version` shows 0.12.x.
2. `:Lazy sync` succeeds.
3. `:Mason` installs `lua_ls`, `pyright`, `texlab`, `ltex_plus`, `verible`, and `vhdl_ls`.
4. `:checkhealth vim.lsp` passes the important checks.
5. Open a Lua file and verify `:LspInfo` shows `lua_ls`.
6. Open a TeX file and verify `:LspInfo` shows `texlab` and `ltex_plus`.
7. In TeX math mode, type `@a`, `ff`, `x1`, `xhat`, and `dm` outside math mode.
8. Run `:CmpStatus` and confirm the active sources include LSP, LuaSnip, path, buffer, and VimTeX where relevant.
9. Run `:Telescope lsp_document_symbols` and `gra` or `<leader>la` for code actions.
