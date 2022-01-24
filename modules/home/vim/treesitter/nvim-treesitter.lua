local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
local config = require('nvim-treesitter.configs')

parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'f110024d539e676f25b72b7c80b0fd43c34264ef',
    files = {'src/parser.c', 'src/scanner.cc'},
  },
  filetype = 'org',
}

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
