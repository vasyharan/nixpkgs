local jdtls = require('jdtls')

jdtls_config = {
  cmd = {'jdt-language-server'},
  on_attach = lsp_on_attach
}

vim.cmd [[augroup Metals]]
vim.cmd [[au!]]
vim.cmd [[au FileType java lua require("jdtls").start_or_attach(jdtls_config)]]
vim.cmd [[augroup end]]
