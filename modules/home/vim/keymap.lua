function keymap(key) -- {{{
  -- get the extra options
  local opts = {noremap = true}
  for i, v in pairs(key) do
    if type(i) == 'string' then opts[i] = v end
  end

  -- basic support for buffer-scoped keybindings
  local buffer = opts.buffer
  opts.buffer = nil

  if buffer then
    vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
  else
    vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
  end
end -- }}}

keymap { 'n', ',f', "<cmd>lua require('telescope.builtin').find_files(ivy)<cr>" }
keymap { 'n', ',g', "<cmd>lua require('telescope.builtin').live_grep()<cr>" }
keymap { 'n', ',*', "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand(\"<cword>\") })<cr>" }
keymap { 'n', ',b', "<cmd>lua require('telescope.builtin').buffers()<cr>" }
keymap { 'n', ',h', "<cmd>lua require('telescope.builtin').help_tags()<cr>" }

keymap { 'n', ',t', "<cmd>NvimTreeToggle<cr>" }
keymap { 'n', ',T', "<cmd>NvimTreeFindFile<cr>" }

keymap { 'n', 'vv', '<cmd>vertical split<cr>' }
keymap { 'n', 'vs', '<cmd>split<cr>' }

keymap { 'n', '<space>q', "<cmd>:Bdelete<cr>" }
keymap { 'n', '<space>w', "<cmd>w<cr>" }
keymap { 'n', '<space>W', "<cmd>wa<cr>" }

keymap { 'n', ',vv', "<cmd>Git<cr>" }
keymap { 'n', ',vl', "<cmd>Git log<cr>" }
keymap { 'n', ',v<space>', ":Git " }
