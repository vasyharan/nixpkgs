local parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters"
vim.fn.mkdir(parser_install_dir, "p")
vim.opt.runtimepath:append(parser_install_dir)

require('nvim-treesitter.configs').setup {
  parser_install_dir = parser_install_dir,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {'org'},
  },
  ensure_installed = {
    'bash',
    'go',
    'graphql',
    'java',
    'javascript',
    'lua',
    'nix',
    'org',
    'python',
    'scala',
    'svelte',
    'hcl',
    'toml',
    'typescript',
  },
}
