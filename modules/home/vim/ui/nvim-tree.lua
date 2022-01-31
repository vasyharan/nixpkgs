local nvimtree = require('nvim-tree')
nvimtree.setup {
  disable_netrw = false,
  view = {
    auto_resize = true,
  },
  filters = {
    dotfiles = false,
    custom = { ".git" },
  },
}
