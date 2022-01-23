local config = require('nvim-treesitter.configs')
config.setup {
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
    'toml',
    'typescript',
  },
}
