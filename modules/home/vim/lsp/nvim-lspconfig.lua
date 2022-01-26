local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')

function lsp_on_attach(client, bufnr) -- {{{
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local protocol = require('vim.lsp.protocol')

  -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- map { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', silent=true }
  keymap { 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', silent=true }
  keymap { 'n', 'K', "<cmd>lua vim.lsp.buf.hover()<cr>", silent = true }
  keymap { 'i', '<C-k>', "<cmd>lua vim.lsp.buf.signature_help()<cr>", silent = true }
  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  keymap { 'n', 'gR', "<cmd>lua vim.lsp.buf.rename()<cr>", silent = true }
  keymap { 'n', 'g.', "<cmd>lua vim.lsp.buf.code_action()<cr>", silent = true }
  -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  keymap { 'n', 'gH', "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", silent = true }
  keymap { 'n', '[e', "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", silent = true }
  keymap { 'n', ']e', "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", silent = true }
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  keymap { 'n', '<space>F', "<cmd>lua vim.lsp.buf.formatting()<CR>", silent = true }

  -- formatting
  if client.resolved_capabilities.document_formatting or
    client.resolved_capabilities.document_range_formatting then
  -- if client.resolved_capabilities.document_formatting then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()]]
    vim.api.nvim_command [[augroup END]]
  end

  -- require('completion').on_attach(client, bufnr)
  require('lsp-status').on_attach(client)

  --protocol.SymbolKind = { }
  protocol.CompletionItemKind = { -- {{{
    '', -- Text
    '', -- Method
    '', -- Function
    '', -- Constructor
    '', -- Field
    '', -- Variable
    '', -- Class
    'ﰮ', -- Interface
    '', -- Module
    '', -- Property
    '', -- Unit
    '', -- Value
    '', -- Enum
    '', -- Keyword
    '﬌', -- Snippet
    '', -- Color
    '', -- File
    '', -- Reference
    '', -- Folder
    '', -- EnumMember
    '', -- Constant
    '', -- Struct
    '', -- Event
    'ﬦ', -- Operator
    '', -- TypeParameter
  } -- }}}
end -- }}}

-- icon {{{
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = true,
  underline = true,
-- virtual_text = false,
  virtual_text = {
    spacing = 4,
    prefix = ''
  }
})
-- }}}
lspconfig.gopls.setup { -- {{{
  cmd = { "gopls", "serve" },
  on_attach = lsp_on_attach,
  capabilities = vim.tbl_extend('keep', {}, lsp_status.capabilities)
} -- }}}
lspconfig.rust_analyzer.setup{ -- {{{
  on_attach = lsp_on_attach,
  capabilities = vim.tbl_extend('keep', {}, lsp_status.capabilities)
} -- }}}
lspconfig.tsserver.setup { -- {{{
  on_attach = lsp_on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" }
} -- }}}
lspconfig.svelte.setup { -- {{{
  on_attach = lsp_on_attach,
} -- }}}
lspconfig.pyright.setup { -- {{{
  on_attach = lsp_on_attach,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
      },
    },
  },
} -- }}}
lspconfig.terraformls.setup { -- {{{
  on_attach = lsp_on_attach,
} -- }}}
