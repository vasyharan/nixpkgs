function keymap(key) -- {{{
  -- get the extra options
  -- local opts = {noremap = true}
  local opts = {}
  for i, v in pairs(key) do
    if type(i) == 'string' then opts[i] = v end
  end

  -- basic support for buffer-scoped keybindings
  local buffer = opts.buffer
  opts.buffer = nil

  if buffer then
    if type(buffer) == 'boolean' then
      vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
    else
      vim.api.nvim_buf_set_keymap(buffer, key[1], key[2], key[3], opts)
    end
  else
    vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
  end
end -- }}}

keymap { 'n', ',f', "<cmd>lua require('telescope.builtin').find_files(ivy)<cr>" }
keymap { 'n', ',g', "<cmd>lua require('telescope.builtin').live_grep()<cr>" }
keymap { 'n', ',*', "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand(\"<cword>\") })<cr>" }
keymap { 'n', ',b', "<cmd>lua require('telescope.builtin').buffers()<cr>" }
keymap { 'n', ',h', "<cmd>lua require('telescope.builtin').help_tags()<cr>" }
keymap { 'n', ',oo', "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>" }

keymap { 'n', ',t', "<cmd>NvimTreeToggle<cr>" }
keymap { 'n', ',T', "<cmd>NvimTreeFindFile<cr>" }

keymap { 'n', 'vv', '<cmd>vertical split<cr>' }
keymap { 'n', 'vs', '<cmd>split<cr>' }

keymap { 'n', '<space>q', "<cmd>:Bdelete<cr>" }
keymap { 'n', '<space>w', "<cmd>w<cr>" }
keymap { 'n', '<space>W', "<cmd>wa<cr>" }

keymap { 'n', '<space>vv', "<cmd>Git<cr>" }
keymap { 'n', '<space>vl', "<cmd>Git log<cr>" }
keymap { 'n', '<space>v<space>', ":Git " }

-- nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
keymap { 'n', '<space>dd', "<cmd>lua require('dap').continue()<cr>" }
keymap { 'n', '<space>dD', "<cmd>lua require('dap').run_last()<cr>" }
keymap { 'n', '<space>db', "<cmd>lua require('dap').toggle_breakpoint()<cr>" }
keymap { 'n', '<space>dB', "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>" }
keymap { 'n', '<space>dr', "<cmd>lua require('dap').repl.open()<cr>" }
keymap { 'n', '<space>du', "<cmd>lua require('dapui').open()<cr>" }
keymap { 'n', '<space>dU', "<cmd>lua require('dapui').close()<cr>" }

keymap { 'n', '<F4>', "<cmd>lua require('dap').toggle_breakpoint()<cr>" }
keymap { 'n', '<F5>', "<cmd>lua require('dap').continue()<cr>" }
keymap { 'n', '<F7>', "<cmd>lua require('dap').step_into()<cr>" }
keymap { 'n', '<F8>', "<cmd>lua require('dap').step_over()<cr>" }
keymap { 'n', '<S-F8>', "<cmd>lua require('dap').step_out()<cr>" }
