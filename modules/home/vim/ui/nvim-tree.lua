local nvimtree = require('nvim-tree')
nvimtree.setup {
  disable_netrw = false,
  view = {
    adaptive_size = true,
    side = "right",
  },
  filters = {
    dotfiles = false,
    custom = { ".git" },
  },
}
