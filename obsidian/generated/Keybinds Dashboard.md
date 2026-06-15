---
type: dashboard
title: Keybinds Dashboard
area: system
updated: '2026-06-15'
tags:
- dashboard/keybinds
- system/dotfiles
---

# Keybinds Dashboard

## Curated keybinds

| App | Area | Platform | Key | Action | Frequency | Importance |
|---|---|---|---|---|---|---|
| aerospace | workspace | macos | `alt-h/j/k/l` | Focus window left/down/up/right | daily | high |
| aerospace | workspace | macos | `alt-shift-h/j/k/l` | Move tiled window left/down/up/right | daily | high |
| aerospace | workspace | macos | `alt-shift-; + f` | Toggle floating/tiling | weekly | high |
| hammerspoon | workspace | macos | `cmd-ctrl-alt-h/j/k/l` | Move floating window | rare | high |
| hammerspoon | workspace | macos | `cmd-ctrl-alt--/=` | Resize floating window width | rare | medium |
| tmux | terminal | common | `prefix + ?` | Show tmux keybindings | rare | high |
| nvim | editor | common | `<leader>pf` | Find files | daily | high |
| nvim | editor | common | `<leader>ps` | Live grep/search project text | daily | high |
| nvim | editor | common | `<leader>vca` | LSP code action | rare | high |
| nvim | editor | common | `<leader>vrn` | Rename symbol | rare | high |

## Rare or high-importance keybinds

| App | Key | Action |
|---|---|---|
| aerospace | `alt-h/j/k/l` | Focus window left/down/up/right |
| aerospace | `alt-shift-h/j/k/l` | Move tiled window left/down/up/right |
| aerospace | `alt-shift-; + f` | Toggle floating/tiling |
| hammerspoon | `cmd-ctrl-alt-h/j/k/l` | Move floating window |
| hammerspoon | `cmd-ctrl-alt--/=` | Resize floating window width |
| tmux | `prefix + ?` | Show tmux keybindings |
| nvim | `<leader>pf` | Find files |
| nvim | `<leader>ps` | Live grep/search project text |
| nvim | `<leader>vca` | LSP code action |
| nvim | `<leader>vrn` | Rename symbol |

## Extracted Neovim keymaps

| Mode | Key | Action |
|---|---|---|
| visual-block | ` y` | "+y |
| visual-block | ` d` | "d |
| visual-block | ` p` | "_dP |
| visual-block | `#` | :help v_#-default |
| visual-block | `%` | <Plug>(MatchitVisualForward) |
| visual-block | `*` | :help v_star-default |
| visual-block | `@` | :help v_@-default |
| visual-block | `J` | :m '>+1<CR>gv=gv |
| visual-block | `K` | :m '<lt>-2<CR>gv=gv |
| visual-block | `Q` | :help v_Q-default |
| visual-block | `S` | Add a surrounding pair around a visual selection |
| visual-block | `[%` | <Plug>(MatchitVisualMultiBackward) |
| visual-block | `[N` | Select previous sibling node |
| visual-block | `[n` | Select previous node |
| visual-block | `]%` | <Plug>(MatchitVisualMultiForward) |
| visual-block | `]N` | Select next sibling node |
| visual-block | `]n` | Select next node |
| visual-block | `a%` | <Plug>(MatchitVisualTextObject) |
| visual-block | `an` | Select parent (outer) node |
| visual-block | `gS` | Add a surrounding pair around a visual selection, on new lines |
| visual-block | `g%` | <Plug>(MatchitVisualBackward) |
| visual-block | `gb` | Comment toggle blockwise (visual) |
| visual-block | `gra` | vim.lsp.buf.code_action() |
| visual-block | `gc` | Comment toggle linewise (visual) |
| visual-block | `gx` | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) |
| visual-block | `in` | Select child (inner) node |
| visual-block | `<Plug>luasnip-expand-repeat` | LuaSnip: Repeat last node expansion |
| visual-block | `<Plug>(nvim-surround-visual-line)` | Add a surrounding pair around a visual selection, on new lines |
| visual-block | `<Plug>(nvim-surround-visual)` | Add a surrounding pair around a visual selection |
| visual-block | `<Plug>(MatchitVisualTextObject)` | <Plug>(MatchitVisualMultiBackward)o<Plug>(MatchitVisualMultiForward) |
| visual-block | `<Plug>(MatchitVisualMultiForward)` | :<C-U>call matchit#MultiMatch("W",  "n")<CR>m'gv`` |
| visual-block | `<Plug>(MatchitVisualMultiBackward)` | :<C-U>call matchit#MultiMatch("bW", "n")<CR>m'gv`` |
| visual-block | `<Plug>(MatchitVisualBackward)` | :<C-U>call matchit#Match_wrapper('',0,'v')<CR>m'gv`` |
| visual-block | `<Plug>(MatchitVisualForward)` | :<C-U>call matchit#Match_wrapper('',1,'v')<CR>:if col("''") != col("$") \| exe ":normal! m'" \| endif<CR>gv`` |
| visual-block | `<Plug>(comment_toggle_blockwise_visual)` | Comment toggle blockwise (visual) |
| visual-block | `<Plug>(comment_toggle_linewise_visual)` | Comment toggle linewise (visual) |
| normal | `<CR>` | Enter newline below cursor in normal mode |
| normal | ` ==` | Auto-align whole file |
| normal | ` wp` | Previous window |
| normal | ` wr` | Rotate windows |
| normal | ` w=` | Equalize splits |
| normal | ` wc` | Close window |
| normal | ` wl` | Move to right window |
| normal | ` wk` | Move to above window |
| normal | ` wj` | Move to below window |
| normal | ` wh` | Move to left window |
| normal | ` wso` | Write and source if Lua/Vim file |
| normal | ` tv` | Toggle vertical terminal |
| normal | ` tt` | Toggles the term |
| normal | ` rn` | Run Python in float terminal |
| normal | ` bb` | :Telescope buffers<CR> |
| normal | ` bp` | :bprev<CR> |
| normal | ` bn` | :bnext<CR> |
| normal | ` ex` | Make current file executable |
| normal | ` Y` | "+Y |
| normal | ` y` | "+y |
| normal | ` d` | "d |
| normal | ` hn` | Previous harpoon |
| normal | ` hp` | Previous harpoon |
| normal | ` h4` | Harpoon 4 |
| normal | ` h3` | Harpoon 3 |
| normal | ` h2` | Harpoon 2 |
| normal | ` h1` | Harpoon 1 |
| normal | ` hf` | Open harpoon menu |
| normal | ` a` | Harpoon file |
| normal | ` cp` | Clipboard |
| normal | ` ps` | Telescope live grep |
| normal | ` pf` | Telescope find files |
| normal | ` pv` | Toggle File Tree |
| normal | ` gd` | Git diff split |
| normal | ` gb` | Git blame |
| normal | ` gs` | Git status (Fugitive) |
| normal | `$` | g$ |
| normal | `%` | <Plug>(MatchitNormalForward) |
| normal | `&` | :help &-default |
| normal | `0` | g0 |
| normal | `J` | mzJ`z |
| normal | `N` | Nzzzv |
| normal | `Y` | :help Y-default |
| normal | `[%` | <Plug>(MatchitNormalMultiBackward) |
| normal | `[ ` | Add empty line above cursor |
| normal | `[B` | :brewind |
| normal | `[b` | :bprevious |
| normal | `[<C-T>` | :ptprevious |
| normal | `[T` | :trewind |
| normal | `[t` | :tprevious |
| normal | `[A` | :rewind |
| normal | `[a` | :previous |
| normal | `[<C-L>` | :lpfile |
| normal | `[L` | :lrewind |
| normal | `[l` | :lprevious |
| normal | `[<C-Q>` | :cpfile |
| normal | `[Q` | :crewind |
| normal | `[q` | :cprevious |
| normal | `[D` | Jump to the first diagnostic in the current buffer |
| normal | `[d` | Jump to the previous diagnostic in the current buffer |
| normal | `]%` | <Plug>(MatchitNormalMultiForward) |
| normal | `] ` | Add empty line below cursor |
| normal | `]B` | :blast |
| normal | `]b` | :bnext |
| normal | `]<C-T>` | :ptnext |
| normal | `]T` | :tlast |
| normal | `]t` | :tnext |
| normal | `]A` | :last |
| normal | `]a` | :next |
| normal | `]<C-L>` | :lnfile |
| normal | `]L` | :llast |
| normal | `]l` | :lnext |
| normal | `]<C-Q>` | :cnfile |
| normal | `]Q` | :clast |
| normal | `]q` | :cnext |
| normal | `]D` | Jump to the last diagnostic in the current buffer |
| normal | `]d` | Jump to the next diagnostic in the current buffer |
| normal | `cS` | Change a surrounding pair, putting replacements on new lines |
| normal | `cs` | Change a surrounding pair |
| normal | `ds` | Delete a surrounding pair |
| normal | `g%` | <Plug>(MatchitNormalBackward) |
| normal | `gcA` | Comment insert end of line |
| normal | `gcO` | Comment insert above |
| normal | `gco` | Comment insert below |
| normal | `gbc` | Comment toggle current block |
| normal | `gb` | Comment toggle blockwise |
| normal | `gO` | vim.lsp.buf.document_symbol() |
| normal | `grt` | vim.lsp.buf.type_definition() |
| normal | `gri` | vim.lsp.buf.implementation() |
| normal | `grr` | vim.lsp.buf.references() |
| normal | `grx` | vim.lsp.codelens.run() |
| normal | `gra` | vim.lsp.buf.code_action() |
| normal | `grn` | vim.lsp.buf.rename() |
| normal | `gcc` | Comment toggle current line |
| normal | `gc` | Comment toggle linewise |
| normal | `gx` | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) |
| normal | `j` | gj |
| normal | `k` | gk |
| normal | `n` | nzzzv |
| normal | `ySS` | Add a surrounding pair around the current line, on new lines (normal mode) |
| normal | `yS` | Add a surrounding pair around a motion, on new lines (normal mode) |
| normal | `yss` | Add a surrounding pair around the current line (normal mode) |
| normal | `ys` | Add a surrounding pair around a motion (normal mode) |
| normal | `<Plug>luasnip-expand-repeat` | LuaSnip: Repeat last node expansion |
| normal | `<Plug>luasnip-delete-check` | LuaSnip: Removes current snippet from jumplist |
| normal | `<Plug>(nvim-surround-change-line)` | Change a surrounding pair, putting replacements on new lines |
| normal | `<Plug>(nvim-surround-change)` | Change a surrounding pair |
| normal | `<Plug>(nvim-surround-delete)` | Delete a surrounding pair |
| normal | `<Plug>(nvim-surround-normal-cur-line)` | Add a surrounding pair around the current line, on new lines (normal mode) |
| normal | `<Plug>(nvim-surround-normal-line)` | Add a surrounding pair around a motion, on new lines (normal mode) |
| normal | `<Plug>(nvim-surround-normal-cur)` | Add a surrounding pair around the current line (normal mode) |
| normal | `<Plug>(nvim-surround-normal)` | Add a surrounding pair around a motion (normal mode) |
| normal | `<S-CR>` | Enter newline below cursor in normal mode |
| normal | `<C-D>` | <C-D>zz |
| normal | `<C-U>` | <C-U>zz |
| normal | `<C-K>` | Toggle cmp autocompletion |
| normal | `<Plug>(MatchitNormalMultiForward)` | :<C-U>call matchit#MultiMatch("W",  "n")<CR> |
| normal | `<Plug>(MatchitNormalMultiBackward)` | :<C-U>call matchit#MultiMatch("bW", "n")<CR> |
| normal | `<Plug>(MatchitNormalBackward)` | :<C-U>call matchit#Match_wrapper('',0,'n')<CR> |
| normal | `<Plug>(MatchitNormalForward)` | :<C-U>call matchit#Match_wrapper('',1,'n')<CR> |
| normal | `<C-Bslash>` | Toggle Terminal |
| normal | `<Plug>PlenaryTestFile` | :lua require('plenary.test_harness').test_file(vim.fn.expand("%:p"))<CR> |
| normal | `<Plug>(comment_toggle_blockwise_count)` | Comment toggle blockwise with count |
| normal | `<Plug>(comment_toggle_linewise_count)` | Comment toggle linewise with count |
| normal | `<Plug>(comment_toggle_blockwise_current)` | Comment toggle current block |
| normal | `<Plug>(comment_toggle_linewise_current)` | Comment toggle current line |
| normal | `<Plug>(comment_toggle_blockwise)` | Comment toggle blockwise |
| normal | `<Plug>(comment_toggle_linewise)` | Comment toggle linewise |
| normal | `<C-W><C-D>` | Show diagnostics under the cursor |
| normal | `<C-W>d` | Show diagnostics under the cursor |
| normal | `<C-L>` | :help CTRL-L-default |
| visual | `<Tab>` | vim.snippet.jump if active, otherwise <Tab> |
| visual | ` y` | "+y |
| visual | ` d` | "d |
| visual | ` p` | "_dP |
| visual | `#` | :help v_#-default |
| visual | `%` | <Plug>(MatchitVisualForward) |
| visual | `*` | :help v_star-default |
| visual | `@` | :help v_@-default |
| visual | `J` | :m '>+1<CR>gv=gv |
| visual | `K` | :m '<lt>-2<CR>gv=gv |
| visual | `Q` | :help v_Q-default |
| visual | `S` | Add a surrounding pair around a visual selection |
| visual | `[%` | <Plug>(MatchitVisualMultiBackward) |
| visual | `[N` | Select previous sibling node |
| visual | `[n` | Select previous node |
| visual | `]%` | <Plug>(MatchitVisualMultiForward) |
| visual | `]N` | Select next sibling node |
| visual | `]n` | Select next node |
| visual | `a%` | <Plug>(MatchitVisualTextObject) |
| visual | `an` | Select parent (outer) node |
| visual | `gS` | Add a surrounding pair around a visual selection, on new lines |
| visual | `g%` | <Plug>(MatchitVisualBackward) |
| visual | `gb` | Comment toggle blockwise (visual) |
| visual | `gra` | vim.lsp.buf.code_action() |
| visual | `gc` | Comment toggle linewise (visual) |
| visual | `gx` | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) |
| visual | `in` | Select child (inner) node |
| visual | `<Plug>luasnip-jump-prev` | LuaSnip: Jump to the previous node |
| visual | `<Plug>luasnip-jump-next` | LuaSnip: Jump to the next node |
| visual | `<Plug>luasnip-prev-choice` | LuaSnip: Change to the previous choice from the choiceNode |
| visual | `<Plug>luasnip-next-choice` | LuaSnip: Change to the next choice from the choiceNode |
| visual | `<Plug>luasnip-expand-snippet` | LuaSnip: Expand the current snippet |
| visual | `<Plug>luasnip-expand-or-jump` | LuaSnip: Expand or jump in the current snippet |
| visual | `<Plug>luasnip-expand-repeat` | LuaSnip: Repeat last node expansion |
| visual | `<Plug>(nvim-surround-visual-line)` | Add a surrounding pair around a visual selection, on new lines |
| visual | `<Plug>(nvim-surround-visual)` | Add a surrounding pair around a visual selection |
| visual | `<Plug>(MatchitVisualTextObject)` | <Plug>(MatchitVisualMultiBackward)o<Plug>(MatchitVisualMultiForward) |
| visual | `<Plug>(MatchitVisualMultiForward)` | :<C-U>call matchit#MultiMatch("W",  "n")<CR>m'gv`` |
| visual | `<Plug>(MatchitVisualMultiBackward)` | :<C-U>call matchit#MultiMatch("bW", "n")<CR>m'gv`` |
| visual | `<Plug>(MatchitVisualBackward)` | :<C-U>call matchit#Match_wrapper('',0,'v')<CR>m'gv`` |
| visual | `<Plug>(MatchitVisualForward)` | :<C-U>call matchit#Match_wrapper('',1,'v')<CR>:if col("''") != col("$") \| exe ":normal! m'" \| endif<CR>gv`` |
| visual | `<Plug>(comment_toggle_blockwise_visual)` | Comment toggle blockwise (visual) |
| visual | `<Plug>(comment_toggle_linewise_visual)` | Comment toggle linewise (visual) |
| visual | `<S-Tab>` | vim.snippet.jump if active, otherwise <S-Tab> |
| visual | `<C-S>` | vim.lsp.buf.signature_help() |
| terminal | `<Esc>` | <C-\><C-N> |
| command | `<Plug>luasnip-expand-repeat` | LuaSnip: Repeat last node expansion |
| command | `<Plug>luasnip-delete-check` | LuaSnip: Removes current snippet from jumplist |
| command | `<Plug>(TelescopeFuzzyCommandSearch)` | <C-\>e "lua require('telescope.builtin').command_history { default_text = [=[" . escape(getcmdline(), '"') . "]=] }"<CR><CR> |
| operator-pending | `%` | <Plug>(MatchitOperationForward) |
| operator-pending | `[%` | <Plug>(MatchitOperationMultiBackward) |
| operator-pending | `]%` | <Plug>(MatchitOperationMultiForward) |
| operator-pending | `an` | Select parent (outer) node |
| operator-pending | `g%` | <Plug>(MatchitOperationBackward) |
| operator-pending | `gc` | Comment textobject |
| operator-pending | `in` | Select child (inner) node |
| operator-pending | `<Plug>luasnip-expand-repeat` | LuaSnip: Repeat last node expansion |
| operator-pending | `<Plug>(MatchitOperationMultiForward)` | :<C-U>call matchit#MultiMatch("W",  "o")<CR> |
| operator-pending | `<Plug>(MatchitOperationMultiBackward)` | :<C-U>call matchit#MultiMatch("bW", "o")<CR> |
| operator-pending | `<Plug>(MatchitOperationBackward)` | :<C-U>call matchit#Match_wrapper('',0,'o')<CR> |
| operator-pending | `<Plug>(MatchitOperationForward)` | :<C-U>call matchit#Match_wrapper('',1,'o')<CR> |
| insert | `<C-N>` | cmp.utils.keymap.set_map |
| insert | `<C-Space>` | cmp.utils.keymap.set_map |
| insert | `<C-E>` | cmp.utils.keymap.set_map |
| insert | `<C-Y>` | cmp.utils.keymap.set_map |
| insert | `<Down>` | cmp.utils.keymap.set_map |
| insert | `<Up>` | cmp.utils.keymap.set_map |
| insert | `<C-P>` | cmp.utils.keymap.set_map |
| insert | `<Plug>luasnip-expand-repeat` | LuaSnip: Repeat last node expansion |
| insert | `<Plug>luasnip-delete-check` | LuaSnip: Removes current snippet from jumplist |
| insert | `<Plug>luasnip-jump-prev` | LuaSnip: Jump to the previous node |
| insert | `<Plug>luasnip-jump-next` | LuaSnip: Jump to the next node |
| insert | `<Plug>luasnip-prev-choice` | LuaSnip: Change to the previous choice from the choiceNode |
| insert | `<Plug>luasnip-next-choice` | LuaSnip: Change to the next choice from the choiceNode |
| insert | `<Plug>luasnip-expand-snippet` | LuaSnip: Expand the current snippet |
| insert | `<Plug>luasnip-expand-or-jump` | LuaSnip: Expand or jump in the current snippet |
| insert | `<Plug>(nvim-surround-insert-line)` | Add a surrounding pair around the cursor, on new lines (insert mode) |
| insert | `<Plug>(nvim-surround-insert)` | Add a surrounding pair around the cursor (insert mode) |
| insert | `<C-G>S` | Add a surrounding pair around the cursor, on new lines (insert mode) |
| insert | `<C-G>s` | Add a surrounding pair around the cursor (insert mode) |
| insert | `<C-Bslash>` | Toggle Terminal |
| insert | `<S-Tab>` | vim.snippet.jump if active, otherwise <S-Tab> |
| insert | `<C-S>` | vim.lsp.buf.signature_help() |
| insert | `<C-W>` | :help i_CTRL-W-default |
| insert | `<C-U>` | :help i_CTRL-U-default |
| insert | `<Tab>` | cmp.utils.keymap.set_map |
| select | `<Tab>` | vim.snippet.jump if active, otherwise <Tab> |
| select | ` y` | "+y |
| select | ` d` | "d |
| select | `J` | :m '>+1<CR>gv=gv |
| select | `K` | :m '<lt>-2<CR>gv=gv |
| select | `<Plug>luasnip-jump-prev` | LuaSnip: Jump to the previous node |
| select | `<Plug>luasnip-jump-next` | LuaSnip: Jump to the next node |
| select | `<Plug>luasnip-prev-choice` | LuaSnip: Change to the previous choice from the choiceNode |
| select | `<Plug>luasnip-next-choice` | LuaSnip: Change to the next choice from the choiceNode |
| select | `<Plug>luasnip-expand-snippet` | LuaSnip: Expand the current snippet |
| select | `<Plug>luasnip-expand-or-jump` | LuaSnip: Expand or jump in the current snippet |
| select | `<Plug>luasnip-expand-repeat` | LuaSnip: Repeat last node expansion |
| select | `<S-Tab>` | vim.snippet.jump if active, otherwise <S-Tab> |
| select | `<C-S>` | vim.lsp.buf.signature_help() |

## Extracted tmux keymaps

Raw tmux output:

~~~text
bind-key    -T copy-mode    Escape                    send-keys -X cancel
bind-key    -T copy-mode    Space                     send-keys -X page-down
bind-key    -T copy-mode    ,                         send-keys -X jump-reverse
bind-key    -T copy-mode    \;                        send-keys -X jump-again
bind-key    -T copy-mode    F                         command-prompt -1 -p "(jump backward)" { send-keys -X jump-backward -- "%%" }
bind-key    -T copy-mode    N                         send-keys -X search-reverse
bind-key    -T copy-mode    P                         send-keys -X toggle-position
bind-key    -T copy-mode    R                         send-keys -X rectangle-toggle
bind-key    -T copy-mode    T                         command-prompt -1 -p "(jump to backward)" { send-keys -X jump-to-backward -- "%%" }
bind-key    -T copy-mode    X                         send-keys -X set-mark
bind-key    -T copy-mode    f                         command-prompt -1 -p "(jump forward)" { send-keys -X jump-forward -- "%%" }
bind-key    -T copy-mode    g                         command-prompt -p "(goto line)" { send-keys -X goto-line -- "%%" }
bind-key    -T copy-mode    n                         send-keys -X search-again
bind-key    -T copy-mode    q                         send-keys -X cancel
bind-key    -T copy-mode    r                         send-keys -X refresh-from-pane
bind-key    -T copy-mode    t                         command-prompt -1 -p "(jump to forward)" { send-keys -X jump-to-forward -- "%%" }
bind-key    -T copy-mode    MouseDown1Pane            select-pane
bind-key    -T copy-mode    MouseDrag1Pane            select-pane \; send-keys -X begin-selection
bind-key    -T copy-mode    MouseDragEnd1Pane         send-keys -X copy-pipe-and-cancel
bind-key    -T copy-mode    WheelUpPane               select-pane \; send-keys -X -N 5 scroll-up
bind-key    -T copy-mode    WheelDownPane             select-pane \; send-keys -X -N 5 scroll-down
bind-key    -T copy-mode    DoubleClick1Pane          select-pane \; send-keys -X select-word \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel
bind-key    -T copy-mode    TripleClick1Pane          select-pane \; send-keys -X select-line \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel
bind-key    -T copy-mode    Home                      send-keys -X start-of-line
bind-key    -T copy-mode    End                       send-keys -X end-of-line
bind-key    -T copy-mode    NPage                     send-keys -X page-down
bind-key    -T copy-mode    PPage                     send-keys -X page-up
bind-key    -T copy-mode    Up                        send-keys -X cursor-up
bind-key    -T copy-mode    Down                      send-keys -X cursor-down
bind-key    -T copy-mode    Left                      send-keys -X cursor-left
bind-key    -T copy-mode    Right                     send-keys -X cursor-right
bind-key    -T copy-mode    M-1                       command-prompt -N -I 1 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode    M-2                       command-prompt -N -I 2 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode    M-3                       command-prompt -N -I 3 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode    M-4                       command-prompt -N -I 4 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode    M-5                       command-prompt -N -I 5 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode    M-6                       command-prompt -N -I 6 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode    M-7                       command-prompt -N -I 7 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode    M-8                       command-prompt -N -I 8 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode    M-9                       command-prompt -N -I 9 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode    M-<                       send-keys -X history-top
bind-key    -T copy-mode    M->                       send-keys -X history-bottom
bind-key    -T copy-mode    M-R                       send-keys -X top-line
bind-key    -T copy-mode    M-b                       send-keys -X previous-word
bind-key    -T copy-mode    M-f                       send-keys -X next-word-end
bind-key    -T copy-mode    M-l                       send-keys -X cursor-centre-horizontal
bind-key    -T copy-mode    M-m                       send-keys -X back-to-indentation
bind-key    -T copy-mode    M-r                       send-keys -X middle-line
bind-key    -T copy-mode    M-v                       send-keys -X page-up
bind-key    -T copy-mode    M-w                       send-keys -X copy-pipe-and-cancel
bind-key    -T copy-mode    M-x                       send-keys -X jump-to-mark
bind-key    -T copy-mode    "M-{"                     send-keys -X previous-paragraph
bind-key    -T copy-mode    "M-}"                     send-keys -X next-paragraph
bind-key    -T copy-mode    M-Up                      send-keys -X halfpage-up
bind-key    -T copy-mode    M-Down                    send-keys -X halfpage-down
bind-key    -T copy-mode    C-Space                   send-keys -X begin-selection
bind-key    -T copy-mode    C-a                       send-keys -X start-of-line
bind-key    -T copy-mode    C-b                       send-keys -X cursor-left
bind-key    -T copy-mode    C-c                       send-keys -X cancel
bind-key    -T copy-mode    C-e                       send-keys -X end-of-line
bind-key    -T copy-mode    C-f                       send-keys -X cursor-right
bind-key    -T copy-mode    C-g                       send-keys -X clear-selection
bind-key    -T copy-mode    C-k                       send-keys -X copy-pipe-end-of-line-and-cancel
bind-key    -T copy-mode    C-l                       send-keys -X cursor-centre-vertical
bind-key    -T copy-mode    C-n                       send-keys -X cursor-down
bind-key    -T copy-mode    C-p                       send-keys -X cursor-up
bind-key    -T copy-mode    C-r                       command-prompt -i -I "#{pane_search_string}" -T search -p "(search up)" { send-keys -X search-backward-incremental -- "%%" }
bind-key    -T copy-mode    C-s                       command-prompt -i -I "#{pane_search_string}" -T search -p "(search down)" { send-keys -X search-forward-incremental -- "%%" }
bind-key    -T copy-mode    C-v                       send-keys -X page-down
bind-key    -T copy-mode    C-w                       send-keys -X copy-pipe-and-cancel
bind-key    -T copy-mode    C-Up                      send-keys -X scroll-up
bind-key    -T copy-mode    C-Down                    send-keys -X scroll-down
bind-key    -T copy-mode    C-M-b                     send-keys -X previous-matching-bracket
bind-key    -T copy-mode    C-M-f                     send-keys -X next-matching-bracket
bind-key    -T copy-mode-vi Enter                     send-keys -X copy-pipe-and-cancel
bind-key    -T copy-mode-vi Escape                    send-keys -X clear-selection
bind-key    -T copy-mode-vi Space                     send-keys -X begin-selection
bind-key    -T copy-mode-vi \#                        send-keys -FX search-backward -- "#{copy_cursor_word}"
bind-key    -T copy-mode-vi \$                        send-keys -X end-of-line
bind-key    -T copy-mode-vi \%                        send-keys -X next-matching-bracket
bind-key    -T copy-mode-vi *                         send-keys -FX search-forward -- "#{copy_cursor_word}"
bind-key    -T copy-mode-vi ,                         send-keys -X jump-reverse
bind-key    -T copy-mode-vi /                         command-prompt -T search -p "(search down)" { send-keys -X search-forward -- "%%" }
bind-key    -T copy-mode-vi 0                         send-keys -X start-of-line
bind-key    -T copy-mode-vi 1                         command-prompt -N -I 1 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi 2                         command-prompt -N -I 2 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi 3                         command-prompt -N -I 3 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi 4                         command-prompt -N -I 4 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi 5                         command-prompt -N -I 5 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi 6                         command-prompt -N -I 6 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi 7                         command-prompt -N -I 7 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi 8                         command-prompt -N -I 8 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi 9                         command-prompt -N -I 9 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi :                         command-prompt -p "(goto line)" { send-keys -X goto-line -- "%%" }
bind-key    -T copy-mode-vi \;                        send-keys -X jump-again
bind-key    -T copy-mode-vi ?                         command-prompt -T search -p "(search up)" { send-keys -X search-backward -- "%%" }
bind-key    -T copy-mode-vi A                         send-keys -X append-selection-and-cancel
bind-key    -T copy-mode-vi B                         send-keys -X previous-space
bind-key    -T copy-mode-vi D                         send-keys -X copy-pipe-end-of-line-and-cancel
bind-key    -T copy-mode-vi E                         send-keys -X next-space-end
bind-key    -T copy-mode-vi F                         command-prompt -1 -p "(jump backward)" { send-keys -X jump-backward -- "%%" }
bind-key    -T copy-mode-vi G                         send-keys -X history-bottom
bind-key    -T copy-mode-vi H                         send-keys -X top-line
bind-key    -T copy-mode-vi J                         send-keys -X scroll-down
bind-key    -T copy-mode-vi K                         send-keys -X scroll-up
bind-key    -T copy-mode-vi L                         send-keys -X bottom-line
bind-key    -T copy-mode-vi M                         send-keys -X middle-line
bind-key    -T copy-mode-vi N                         send-keys -X search-reverse
bind-key    -T copy-mode-vi P                         send-keys -X toggle-position
bind-key    -T copy-mode-vi T                         command-prompt -1 -p "(jump to backward)" { send-keys -X jump-to-backward -- "%%" }
bind-key    -T copy-mode-vi V                         send-keys -X select-line
bind-key    -T copy-mode-vi W                         send-keys -X next-space
bind-key    -T copy-mode-vi X                         send-keys -X set-mark
bind-key    -T copy-mode-vi ^                         send-keys -X back-to-indentation
bind-key    -T copy-mode-vi b                         send-keys -X previous-word
bind-key    -T copy-mode-vi e                         send-keys -X next-word-end
bind-key    -T copy-mode-vi f                         command-prompt -1 -p "(jump forward)" { send-keys -X jump-forward -- "%%" }
bind-key    -T copy-mode-vi g                         send-keys -X history-top
bind-key    -T copy-mode-vi h                         send-keys -X cursor-left
bind-key    -T copy-mode-vi j                         send-keys -X cursor-down
bind-key    -T copy-mode-vi k                         send-keys -X cursor-up
bind-key    -T copy-mode-vi l                         send-keys -X cursor-right
bind-key    -T copy-mode-vi n                         send-keys -X search-again
bind-key    -T copy-mode-vi o                         send-keys -X other-end
bind-key    -T copy-mode-vi q                         send-keys -X cancel
bind-key    -T copy-mode-vi r                         send-keys -X refresh-from-pane
bind-key    -T copy-mode-vi t                         command-prompt -1 -p "(jump to forward)" { send-keys -X jump-to-forward -- "%%" }
bind-key    -T copy-mode-vi v                         send-keys -X rectangle-toggle
bind-key    -T copy-mode-vi w                         send-keys -X next-word
bind-key    -T copy-mode-vi z                         send-keys -X scroll-middle
bind-key    -T copy-mode-vi \{                        send-keys -X previous-paragraph
bind-key    -T copy-mode-vi \}                        send-keys -X next-paragraph
bind-key    -T copy-mode-vi MouseDown1Pane            select-pane
bind-key    -T copy-mode-vi MouseDrag1Pane            select-pane \; send-keys -X begin-selection
bind-key    -T copy-mode-vi MouseDragEnd1Pane         send-keys -X copy-pipe-and-cancel
bind-key    -T copy-mode-vi WheelUpPane               select-pane \; send-keys -X -N 5 scroll-up
bind-key    -T copy-mode-vi WheelDownPane             select-pane \; send-keys -X -N 5 scroll-down
bind-key    -T copy-mode-vi DoubleClick1Pane          select-pane \; send-keys -X select-word \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel
bind-key    -T copy-mode-vi TripleClick1Pane          select-pane \; send-keys -X select-line \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel
bind-key    -T copy-mode-vi BSpace                    send-keys -X cursor-left
bind-key    -T copy-mode-vi Home                      send-keys -X start-of-line
bind-key    -T copy-mode-vi End                       send-keys -X end-of-line
bind-key    -T copy-mode-vi NPage                     send-keys -X page-down
bind-key    -T copy-mode-vi PPage                     send-keys -X page-up
bind-key    -T copy-mode-vi Up                        send-keys -X cursor-up
bind-key    -T copy-mode-vi Down                      send-keys -X cursor-down
bind-key    -T copy-mode-vi Left                      send-keys -X cursor-left
bind-key    -T copy-mode-vi Right                     send-keys -X cursor-right
bind-key    -T copy-mode-vi M-x                       send-keys -X jump-to-mark
bind-key    -T copy-mode-vi C-b                       send-keys -X page-up
bind-key    -T copy-mode-vi C-c                       send-keys -X cancel
bind-key    -T copy-mode-vi C-d                       send-keys -X halfpage-down
bind-key    -T copy-mode-vi C-e                       send-keys -X scroll-down
bind-key    -T copy-mode-vi C-f                       send-keys -X page-down
bind-key    -T copy-mode-vi C-h                       send-keys -X cursor-left
bind-key    -T copy-mode-vi C-j                       send-keys -X copy-pipe-and-cancel
bind-key    -T copy-mode-vi C-u                       send-keys -X halfpage-up
bind-key    -T copy-mode-vi C-v                       send-keys -X rectangle-toggle
bind-key    -T copy-mode-vi C-y                       send-keys -X scroll-up
bind-key    -T copy-mode-vi C-Up                      send-keys -X scroll-up
bind-key    -T copy-mode-vi C-Down                    send-keys -X scroll-down
bind-key    -T prefix       Space                     last-window
bind-key    -T prefix       !                         break-pane
bind-key    -T prefix       \#                        list-buffers
bind-key    -T prefix       \$                        command-prompt -I "#S" { rename-session "%%" }
bind-key    -T prefix       &                         confirm-before -p "kill-window #W? (y/n)" kill-window
bind-key    -T prefix       \'                        switch-client -t "{marked}"
bind-key    -T prefix       (                         switch-client -p
bind-key    -T prefix       )                         switch-client -n
bind-key    -T prefix       ,                         command-prompt -I "#W" { rename-window "%%" }
bind-key    -T prefix       -                         delete-buffer
bind-key    -T prefix       .                         command-prompt -T target { move-window -t "%%" }
bind-key    -T prefix       /                         command-prompt -k -p key { list-keys -1N "%%" }
bind-key    -T prefix       0                         select-window -t :=0
bind-key    -T prefix       1                         select-window -t :=1
bind-key    -T prefix       2                         select-window -t :=2
bind-key    -T prefix       3                         select-window -t :=3
bind-key    -T prefix       4                         select-window -t :=4
bind-key    -T prefix       5                         select-window -t :=5
bind-key    -T prefix       6                         select-window -t :=6
bind-key    -T prefix       7                         select-window -t :=7
bind-key    -T prefix       8                         select-window -t :=8
bind-key    -T prefix       9                         select-window -t :=9
bind-key    -T prefix       :                         command-prompt
bind-key    -T prefix       \;                        last-pane
bind-key -r -T prefix       <                         swap-window -d -t -1
bind-key    -T prefix       =                         choose-buffer -Z
bind-key -r -T prefix       >                         swap-window -d -t +1
bind-key    -T prefix       ?                         list-keys -N
bind-key    -T prefix       C                         customize-mode -Z
bind-key    -T prefix       D                         choose-client -Z
bind-key    -T prefix       E                         select-layout -E
bind-key    -T prefix       G                         choose-tree -w "join-pane -s \"%%\""
bind-key    -T prefix       I                         run-shell /Users/joe8922/.tmux/plugins/tpm/bindings/install_plugins
bind-key    -T prefix       L                         switch-client -l
bind-key    -T prefix       M                         select-pane -M
bind-key    -T prefix       R                         run-shell " \t\t\ttmux source-file /Users/joe8922/.tmux.conf > /dev/null; \t\t\ttmux display-message 'Sourced /Users/joe8922/.tmux.conf!'"
bind-key    -T prefix       U                         run-shell /Users/joe8922/.tmux/plugins/tpm/bindings/update_plugins
bind-key    -T prefix       [                         previous-window
bind-key    -T prefix       \\                        switch-client -l
bind-key    -T prefix       ]                         next-window
bind-key    -T prefix       _                         split-window -v -c "#{pane_current_path}"
bind-key    -T prefix       a                         new-window -c "#{pane_current_path}"
bind-key    -T prefix       c                         new-window
bind-key    -T prefix       d                         detach-client
bind-key    -T prefix       f                         command-prompt { find-window -Z "%%" }
bind-key    -T prefix       g                         choose-tree -w "join-pane -h -s \"%%\""
bind-key    -T prefix       h                         select-pane -L
bind-key    -T prefix       i                         display-message
bind-key    -T prefix       j                         select-pane -D
bind-key    -T prefix       k                         select-pane -U
bind-key    -T prefix       l                         select-pane -R
bind-key    -T prefix       m                         select-pane -m
bind-key    -T prefix       n                         next-window
bind-key    -T prefix       o                         select-pane -t :.+
bind-key    -T prefix       p                         previous-window
bind-key    -T prefix       q                         display-panes
bind-key    -T prefix       r                         source-file /Users/joe8922/.tmux.conf
bind-key    -T prefix       s                         choose-tree -Zs
bind-key    -T prefix       t                         clock-mode
bind-key    -T prefix       w                         choose-tree -Zw
bind-key    -T prefix       x                         confirm-before -p "kill-pane #P? (y/n)" kill-pane
bind-key    -T prefix       z                         resize-pane -Z
bind-key    -T prefix       \{                        swap-pane -U
bind-key    -T prefix       |                         split-window -h -c "#{pane_current_path}"
bind-key    -T prefix       \}                        swap-pane -D
bind-key    -T prefix       \~                        show-messages
bind-key -r -T prefix       DC                        refresh-client -c
bind-key    -T prefix       PPage                     copy-mode -u
bind-key -r -T prefix       Up                        select-pane -U
bind-key -r -T prefix       Down                      select-pane -D
bind-key -r -T prefix       Left                      select-pane -L
bind-key -r -T prefix       Right                     select-pane -R
bind-key    -T prefix       M-1                       select-layout even-horizontal
bind-key    -T prefix       M-2                       select-layout even-vertical
bind-key    -T prefix       M-3                       select-layout main-horizontal
bind-key    -T prefix       M-4                       select-layout main-vertical
bind-key    -T prefix       M-5                       select-layout tiled
bind-key    -T prefix       M-6                       select-layout main-horizontal-mirrored
bind-key    -T prefix       M-7                       select-layout main-vertical-mirrored
bind-key    -T prefix       M-n                       next-window -a
bind-key    -T prefix       M-o                       rotate-window -D
bind-key    -T prefix       M-p                       previous-window -a
bind-key    -T prefix       M-u                       run-shell /Users/joe8922/.tmux/plugins/tpm/bindings/clean_plugins
bind-key -r -T prefix       M-Up                      resize-pane -U 5
bind-key -r -T prefix       M-Down                    resize-pane -D 5
bind-key -r -T prefix       M-Left                    resize-pane -L 5
bind-key -r -T prefix       M-Right                   resize-pane -R 5
bind-key    -T prefix       C-_                       send-prefix
bind-key -r -T prefix       C-h                       resize-pane -L 15
bind-key -r -T prefix       C-j                       resize-pane -D 15
bind-key -r -T prefix       C-k                       resize-pane -U 15
bind-key -r -T prefix       C-l                       resize-pane -R 15
bind-key    -T prefix       C-n                       next-window
bind-key    -T prefix       C-o                       rotate-window
bind-key    -T prefix       C-p                       previous-window
bind-key    -T prefix       C-z                       suspend-client
bind-key -r -T prefix       C-Up                      resize-pane -U
bind-key -r -T prefix       C-Down                    resize-pane -D
bind-key -r -T prefix       C-Left                    resize-pane -L
bind-key -r -T prefix       C-Right                   resize-pane -R
bind-key -r -T prefix       S-Up                      refresh-client -U 10
bind-key -r -T prefix       S-Down                    refresh-client -D 10
bind-key -r -T prefix       S-Left                    refresh-client -L 10
bind-key -r -T prefix       S-Right                   refresh-client -R 10
bind-key    -T root         MouseDown1Pane            select-pane -t = \; send-keys -M
bind-key    -T root         MouseDown1Status          switch-client -t =
bind-key    -T root         MouseDown1ScrollbarUp     copy-mode -u
bind-key    -T root         MouseDown1ScrollbarDown   copy-mode -d
bind-key    -T root         MouseDown2Pane            select-pane -t = \; if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { paste-buffer -p }
bind-key    -T root         MouseDown3Pane            if-shell -F -t = "#{||:#{mouse_any_flag},#{&&:#{pane_in_mode},#{?#{m/r:(copy|view)-mode,#{pane_mode}},0,1}}}" { select-pane -t = ; send-keys -M } { display-menu -T "#[align=centre]#{pane_index} (#{pane_id})" -t = -x M -y M "#{?#{m/r:(copy|view)-mode,#{pane_mode}},Go To Top,}" < { send-keys -X history-top } "#{?#{m/r:(copy|view)-mode,#{pane_mode}},Go To Bottom,}" > { send-keys -X history-bottom } '' "#{?mouse_word,Search For #[underscore]#{=/9/...:mouse_word},}" C-r { if-shell -F "#{?#{m/r:(copy|view)-mode,#{pane_mode}},0,1}" "copy-mode -t=" ; send-keys -X -t = search-backward -- "#{q:mouse_word}" } "#{?mouse_word,Type #[underscore]#{=/9/...:mouse_word},}" C-y { copy-mode -q ; send-keys -l "#{q:mouse_word}" } "#{?mouse_word,Copy #[underscore]#{=/9/...:mouse_word},}" c { copy-mode -q ; set-buffer "#{q:mouse_word}" } "#{?mouse_line,Copy Line,}" l { copy-mode -q ; set-buffer "#{q:mouse_line}" } '' "#{?mouse_hyperlink,Type #[underscore]#{=/9/...:mouse_hyperlink},}" C-h { copy-mode -q ; send-keys -l "#{q:mouse_hyperlink}" } "#{?mouse_hyperlink,Copy #[underscore]#{=/9/...:mouse_hyperlink},}" h { copy-mode -q ; set-buffer "#{q:mouse_hyperlink}" } '' "Horizontal Split" h { split-window -h } "Vertical Split" v { split-window -v } '' "#{?#{>:#{window_panes},1},,-}Swap Up" u { swap-pane -U } "#{?#{>:#{window_panes},1},,-}Swap Down" d { swap-pane -D } "#{?pane_marked_set,,-}Swap Marked" s { swap-pane } '' Kill X { kill-pane } Respawn R { respawn-pane -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } "#{?#{>:#{window_panes},1},,-}#{?window_zoomed_flag,Unzoom,Zoom}" z { resize-pane -Z } }
bind-key    -T root         MouseDown3Status          display-menu -T "#[align=centre]#{window_index}:#{window_name}" -t = -x W -y W "#{?#{>:#{session_windows},1},,-}Swap Left" l { swap-window -t :-1 } "#{?#{>:#{session_windows},1},,-}Swap Right" r { swap-window -t :+1 } "#{?pane_marked_set,,-}Swap Marked" s { swap-window } '' Kill X { kill-window } Respawn R { respawn-window -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } Rename n { command-prompt -F -I "#W" { rename-window -t "#{window_id}" "%%" } } '' "New After" w { new-window -a } "New At End" W { new-window }
bind-key    -T root         MouseDown3StatusLeft      display-menu -T "#[align=centre]#{session_name}" -t = -x M -y W Next n { switch-client -n } Previous p { switch-client -p } '' Renumber N { move-window -r } Rename n { command-prompt -I "#S" { rename-session "%%" } } '' "New Session" s { new-session } "New Window" w { new-window }
bind-key    -T root         MouseDrag1Pane            if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -M }
bind-key    -T root         MouseDrag1ScrollbarSlider copy-mode -S
bind-key    -T root         MouseDrag1Border          resize-pane -M
bind-key    -T root         WheelUpPane               if-shell -F "#{||:#{alternate_on},#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -e }
bind-key    -T root         WheelUpStatus             previous-window
bind-key    -T root         WheelDownStatus           next-window
bind-key    -T root         DoubleClick1Pane          select-pane -t = \; if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -H ; send-keys -X select-word ; run-shell -d 0.3 ; send-keys -X copy-pipe-and-cancel }
bind-key    -T root         TripleClick1Pane          select-pane -t = \; if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -H ; send-keys -X select-line ; run-shell -d 0.3 ; send-keys -X copy-pipe-and-cancel }
bind-key    -T root         M-MouseDown3Pane          display-menu -T "#[align=centre]#{pane_index} (#{pane_id})" -t = -x M -y M "#{?#{m/r:(copy|view)-mode,#{pane_mode}},Go To Top,}" < { send-keys -X history-top } "#{?#{m/r:(copy|view)-mode,#{pane_mode}},Go To Bottom,}" > { send-keys -X history-bottom } '' "#{?mouse_word,Search For #[underscore]#{=/9/...:mouse_word},}" C-r { if-shell -F "#{?#{m/r:(copy|view)-mode,#{pane_mode}},0,1}" "copy-mode -t=" ; send-keys -X -t = search-backward -- "#{q:mouse_word}" } "#{?mouse_word,Type #[underscore]#{=/9/...:mouse_word},}" C-y { copy-mode -q ; send-keys -l "#{q:mouse_word}" } "#{?mouse_word,Copy #[underscore]#{=/9/...:mouse_word},}" c { copy-mode -q ; set-buffer "#{q:mouse_word}" } "#{?mouse_line,Copy Line,}" l { copy-mode -q ; set-buffer "#{q:mouse_line}" } '' "#{?mouse_hyperlink,Type #[underscore]#{=/9/...:mouse_hyperlink},}" C-h { copy-mode -q ; send-keys -l "#{q:mouse_hyperlink}" } "#{?mouse_hyperlink,Copy #[underscore]#{=/9/...:mouse_hyperlink},}" h { copy-mode -q ; set-buffer "#{q:mouse_hyperlink}" } '' "Horizontal Split" h { split-window -h } "Vertical Split" v { split-window -v } '' "#{?#{>:#{window_panes},1},,-}Swap Up" u { swap-pane -U } "#{?#{>:#{window_panes},1},,-}Swap Down" d { swap-pane -D } "#{?pane_marked_set,,-}Swap Marked" s { swap-pane } '' Kill X { kill-pane } Respawn R { respawn-pane -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } "#{?#{>:#{window_panes},1},,-}#{?window_zoomed_flag,Unzoom,Zoom}" z { resize-pane -Z }
bind-key    -T root         M-MouseDown3Status        display-menu -T "#[align=centre]#{window_index}:#{window_name}" -t = -x W -y W "#{?#{>:#{session_windows},1},,-}Swap Left" l { swap-window -t :-1 } "#{?#{>:#{session_windows},1},,-}Swap Right" r { swap-window -t :+1 } "#{?pane_marked_set,,-}Swap Marked" s { swap-window } '' Kill X { kill-window } Respawn R { respawn-window -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } Rename n { command-prompt -F -I "#W" { rename-window -t "#{window_id}" "%%" } } '' "New After" w { new-window -a } "New At End" W { new-window }
bind-key    -T root         M-MouseDown3StatusLeft    display-menu -T "#[align=centre]#{session_name}" -t = -x M -y W Next n { switch-client -n } Previous p { switch-client -p } '' Renumber N { move-window -r } Rename n { command-prompt -I "#S" { rename-session "%%" } } '' "New Session" s { new-session } "New Window" w { new-window }
~~~
