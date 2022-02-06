local dap = require('dap')
local dapui = require('dapui')
local dapvt = require('nvim-dap-virtual-text')

vim.fn.sign_define('DapBreakpoint', {text='', texthl='Error', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='', texthl='Conditional', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='', texthl='Normal', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='→', texthl='Debug', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='Error', linehl='', numhl=''})

-- transient keymaps {{{
local keymap_restore = {}
local save_and_delete_buf_keymap = function(buf, key, kmap)
  if kmap.lhs == key then
    table.insert(keymap_restore, kmap)
    vim.api.nvim_buf_del_keymap(buf, 'n', key)
  end
end

local save_and_delete_keymap = function(key, kmap)
  if kmap.lhs == key then
    table.insert(keymap_restore, kmap)
    vim.api.nvim_del_keymap('n', key)
  end
end

dap.listeners.after['event_initialized']['me'] = function()
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    local kmaps = vim.api.nvim_buf_get_keymap(buf, 'n')
    for _, kmap in pairs(kmaps) do
      save_and_delete_buf_keymap(buf, "<C-i>", kmap)
      save_and_delete_buf_keymap(buf, "<C-o>", kmap)
      save_and_delete_buf_keymap(buf, "<C-p>", kmap)
    end
  end

  local kmaps = vim.api.nvim_get_keymap('n')
  for _, kmap in pairs(kmaps) do
    save_and_delete_keymap("<C-i>", kmap)
    save_and_delete_keymap("<C-o>", kmap)
    save_and_delete_keymap("<C-p>", kmap)
  end
  keymap { 'n', '<C-i>', "<cmd>lua require('dap').step_into()<cr>",  silent = true }
  keymap { 'n', '<C-o>', "<cmd>lua require('dap').step_out()<cr>", silent = true }
  keymap { 'n', '<C-p>', "<cmd>lua require('dap').step_over()<cr>",  silent = true }
end

dap.listeners.after['event_terminated']['me'] = function()
  for _, kmap in pairs(keymap_restore) do
    if kmap.buffer then
      vim.api.nvim_buf_set_keymap(
        kmap.buffer,
        kmap.mode,
        kmap.lhs,
        kmap.rhs,
        { silent = kmap.silent == 1 }
      )
    else
      vim.api.nvim_set_keymap(
        kmap.mode,
        kmap.lhs,
        kmap.rhs,
        { silent = kmap.silent == 1 }
      )
    end
  end
  keymap_restore = {}
end
-- }}}

-- dapui setup {{{
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
-- }}}

dapvt.setup()
