" Change leader key to ,
let g:mapleader = ","
set encoding=utf-8
set shell=/bin/zsh

" Turn off mouse clicking
" set mouse=""

set number " line numbering
set relativenumber
" autocmd InsertEnter * :set number
" autocmd InsertLeave * :set relativenumber

" Keyboard shortcuts
  " Saving/quitting
  map <leader>w :w<cr>
  map <leader>q :q<cr>
  map <leader>x :x<cr>
  " End of line
  map e $
  " Copy to clipboard
  vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
  " Jump into ex mode with space
  nnoremap <space> :
  " Switch between the last two files
  nnoremap <leader><leader> <c-^>
  " Indent file
  map <leader>i ggVG=<c-o><c-o>


" Highlight search results
set hlsearch
" Incremental search, search as you type
set incsearch
" Ignore case when searching
set ignorecase
" Ignore case when searching lowercase
set smartcase
" Stop highlighting on Enter
map <ESC> :noh<CR>

" highlight cursor position
" set cursorline
" set cursorcolumn

" Set the title of the iterm tab
set title

call plug#begin('~/.config/nvim/plugged')

  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    " deoplete config
    let g:deoplete#enable_at_startup = 1
    " use tab for completion
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

  " Polyglot loads language support on demand!
  Plug 'sheerun/vim-polyglot'

  " Dark Theme
  Plug 'joshdick/onedark.vim'

  " Execute code checks, find mistakes, in the background
  Plug 'neomake/neomake'
    " Run Neomake when I save any buffer
    autocmd! BufWritePost * Neomake
    let g:neomake_javascript_enabled_makers = ['eslint']

    " Use local eslint for neomake
    Plug 'jaawerth/neomake-local-eslint-first'

  " Friendly navigation
  Plug 'christoomey/vim-tmux-navigator'

  " Git integration
  Plug 'tpope/vim-fugitive'

  " Integrate elixir with vim
  Plug 'slashmili/alchemist.vim'
    map <C-i> K
  " Format elixir docs nicely
  Plug 'powerman/vim-plugin-AnsiEsc'

  " Tree nav
  Plug 'scrooloose/nerdtree'
    " Toggle
    map <C-n> :NERDTreeToggle<cr>
  Plug 'airblade/vim-gitgutter'
  Plug 'rking/ag.vim'

  " Comment shortcuts
  Plug 'vim-scripts/tComment'

  " Ctrl p fuzzy file search
  Plug 'ctrlpvim/ctrlp.vim'
    " Ignore files ignored by gitignore
    let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
    " Search tags
    nnoremap <leader>. :CtrlPTag<cr>

  " Start screen
  Plug 'mhinz/vim-startify'

  " Tags
  Plug 'ludovicchabant/vim-gutentags'
    let g:gutentags_cache_dir = '~/.tags_cache'

  " Change cursor to blinking line when in insert mode
  Plug 'jszakmeister/vim-togglecursor'

  " Reveal file in finder
  Plug 'henrik/vim-reveal-in-finder'

"  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
"    " Mapping selecting mappings
"    nnoremap <C-p> :Files<CR>

  " Plug 'junegunn/fzf.vim'

call plug#end()

" Theme defaults
set background=dark
syntax on
colorscheme onedark

" Sane tabs
" - Two spaces wide
set tabstop=2
set softtabstop=2
" - Expand them all
set expandtab
" - Indent by 2 spaces by default
set shiftwidth=2



