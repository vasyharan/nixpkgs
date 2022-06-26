let mapleader = ' '

set encoding=utf-8
set clipboard=unnamed                                 " yank and paste with the system clipboard
set number relativenumber                             " show line numbers
set linebreak                                         " break lines at word (requires Wrap lines)
set showbreak=+++                                     " wrap-broken line prefix
" set textwidth=100                                   " line wrap (number of cols)
set showmatch                                         " Highlight matching brace
set visualbell                                        " Use visual bell (no beeping)
set directory-=.                                      " don't store swapfiles in the current directory
set hlsearch                                          " hightlight search
set smartcase                                         " case-sensitive search if any caps
set ignorecase                                        " case-insensitive search
set incsearch                                         " search as you type
" set laststatus=2                                    " always show statusline
set scrolloff=3                                       " show context above/below cursorline
set expandtab                                         " expand tabs to spaces
set shiftwidth=2                                      " normal mode indentation commands use 2 spaces
set smartindent                                       " Enable smart-indent
set autoindent                                        " auto-indent new lines
set smarttab                                          " Enable smart-tabs
set softtabstop=2                                     " insert mode tab and backspace use 2 spaces
set tabstop=2                                         " actual tabs occupy 2 characters

"# Advanced
set ruler                                             " show where you are
set list                                              " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
" set undolevels=1000   " Number of undo levels
set backspace=indent,eol,start  " Backspace behaviour
set autoread                                          " reload files when changed on disk
set autowrite                                         " auto write on make
set wildmode=longest:full
set hidden                                            " hidden buffers are the shit!
set inccommand=nosplit                                " preview inc command results
set signcolumn=auto
set viewoptions-=options
" set tags=./.git/tags;,tags
" set shortmess-=F
" set shortmess+=c
" set signcolumn=yes
" set backspace=2                                       " Fix broken backspace in some setups
" set backupcopy=yes                                    " see :help crontab
" set showcmd
" set wildignore=log,node_modules,target,tmp,dist,*.rbc
" set wildmenu                                          " show a navigable menu for tab completion
" set modeline                                          " love me some modelines
" set modelines=5
" set updatetime=250
" set viewoptions-=curdir
" set gdefault
" set cmdheight=2

let g:markdown_folding=1

augroup View
  au!
  let btToIgnore = ['terminal', 'nofile']
  au BufWinLeave ?* if index(btToIgnore, &buftype) < 0 | silent! mkview | endif
  au BufWinEnter ?* if index(btToIgnore, &buftype) < 0 | silent! loadview | endif
augroup END

augroup WorklogHack
  au!
  au BufRead worklog.org nmap <buffer> <C-A> <Plug>SpeedDatingUp | nmap <buffer> <C-X> <Plug>SpeedDatingDown
augroup END
