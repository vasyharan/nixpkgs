if exists('+termguicolors')
  set termguicolors
endif

if exists("&termguicolors") && exists("&winblend")
  syntax enable
  set termguicolors
  set winblend=0
  set wildoptions=pum
  set pumblend=5
endif

if filereadable(expand("~/.config/nvim/background.vim"))
  source ~/.config/nvim/background.vim
else
  set background=dark
endif

colorscheme snazzy

