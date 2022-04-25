local nvimtree = require('nvim-tree')
nvimtree.setup {
  disable_netrw = false,
  view = {
    auto_resize = true,
    side = "right",
  },
  filters = {
    dotfiles = false,
    custom = { ".git" },
  },
}
