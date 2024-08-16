local lspconfig = require('lspconfig')
local cmp_lsp = require('cmp_nvim_lsp')

local function lsp_on_attach(client, bufnr) -- {{{
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local protocol = require('vim.lsp.protocol')

  -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  keymap { 'n', 'gd', "<cmd>lua require'telescope.builtin'.lsp_definitions()<cr>" }
  keymap { 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', silent=true }
  keymap { 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', silent = true }
  keymap { 'i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', silent = true }
  keymap { 'n', 'gi', "<cmd>lua require'telescope.builtin'.lsp_implementations()<cr>" }
  keymap { 'n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', silent = true }
  keymap { 'n', 'g.', '<cmd>lua vim.lsp.buf.code_action()<cr>', silent = true }
  keymap { 'n', 'gr', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>' }
  keymap { 'n', 'ge', '<cmd>lua vim.diagnostic.open_float()<cr>', silent = true }
  keymap { 'n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', silent = true }
  keymap { 'n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', silent = true }
  keymap { 'n', '<space>F', '<cmd>lua vim.lsp.buf.formatting()<CR>', silent = true }


  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- formatting
  if client.server_capabilities.documentFormattingProvider or
    client.server_capabilities.documentRangeFormattingProvider then
  -- if client.resolved_capabilities.document_formatting then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true })]]
    vim.api.nvim_command [[augroup END]]
  end

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

function lspconfig_setup(server, config)
  -- Setup lspconfig.
  local capabilities = vim.tbl_extend('keep',
    config.capabilities or {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
  )

  lspconfig[server].setup(vim.tbl_extend('keep', config, {
    on_attach = lsp_on_attach,
    capabilities = capabilities
  }))
end

lspconfig_setup('gopls', {
  settings = {
    gopls = {
      buildFlags = {'-tags=integration'},
      staticcheck = true,
    },
  },
})
lspconfig_setup('pyright', { -- {{{
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'workspace',
        useLibraryCodeForTypes = true,
      },
    },
  },
}) -- }}}
lspconfig_setup('rust_analyzer', {})
lspconfig_setup('svelte', {})
lspconfig_setup('terraformls', {})
lspconfig_setup('jsonnet_ls', {})
lspconfig_setup('tsserver', { -- {{{
  filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
}) -- }}}


vim.api.nvim_create_autocmd("FileType", { -- {{{ metals
  pattern = { "scala", "sbt" },
  callback = function()
    local metals = require("metals")
    local config = metals.bare_config()
    config.settings = {
      useGlobalExecutable = true,
    }
    local capabilities = vim.tbl_extend('keep',
      config.capabilities or {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )
    config.on_attach = lsp_on_attach
    config.capabilities = capabilities
    metals.initialize_or_attach(config)
  end,
  group = vim.api.nvim_create_augroup("nvim-metals", { clear = true }),
}) -- }}}

vim.api.nvim_create_autocmd("FileType", { -- {{{ jdtls
  pattern = { "java" },
  callback = function()
    local jdtls = require("jdtls")
    local capabilities = vim.tbl_extend('keep',
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )
    local config = {
      cmd = {'jdt-language-server'},
      root_dir = vim.fs.dirname(vim.fs.find({'.gradlew', '.git', 'mvnw'}, { upward = true })[1]),
      capabilities = capabilities,
      on_attach = lsp_on_attach,
    }
    jdtls.start_or_attach(config)
  end,
  group = vim.api.nvim_create_augroup("nvim-jdtls", { clear = true }),
}) -- }}}
