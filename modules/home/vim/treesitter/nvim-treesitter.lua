require'nvim-treesitter.configs'.setup {
  highlight = { enable = true, },
  ensure_installed = {
    "bash",
    "go",
    "graphql",
    "java",
    "javascript",
    "lua",
    "nix",
    "python",
    "scala",
    "svelte",
    "toml",
    "typescript",
  },
}

