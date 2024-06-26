" if exists('+termguicolors')
"   set termguicolors
" endif
if (has("termguicolors"))
  set termguicolors
endif

if has("termguicolors") && has("winblend")
  set termguicolors
  set winblend=0
  set wildoptions=pum
  set pumblend=5
endif

syntax enable
if filereadable(expand("~/.config/nvim/background.vim"))
  source ~/.config/nvim/background.vim
else
  set background=dark
endif

colorscheme gruvbox
