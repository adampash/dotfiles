" Change leader key to ,
let g:mapleader = ","
set encoding=utf-8
set shell=/bin/zsh

" Turn off mouse clicking
set mouse=""

" Show line & column num in status
set ruler

" Save undo history
set undofile
set hidden
set undodir=~/.vimundo/

set number " line numbering
set relativenumber
" autocmd InsertEnter * :set number
" autocmd InsertLeave * :set relativenumber

" Keyboard shortcuts
  " Saving/quitting
  map <leader>w :w<cr>
  map <leader>q :q<cr>
  map <leader>x :x<cr>
  map <leader>ag :Ag! 
  map rw *:%s//
  " End of line
  map e $
  " Copy to clipboard
  vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>

  " Jump into ex mode with space
  nnoremap <space> :
  " Switch between the last two files
  nnoremap ;; <c-^>
  " Don't skip to next result on *
  nnoremap * *``
  " Indent file
  " map <leader>i ggVG=<c-o><c-o>
  map <leader>i :call Format()<cr>
  "Move around splits with <c-hjkl>
  nnoremap <c-j> <c-w>j
  nnoremap <c-k> <c-w>k
  nnoremap <c-h> <c-w>h
  nnoremap <c-l> <c-w>l
  " Run cli command
  map <leader>c :!
  " 0 to beginning of text not line
  map 0 ^
  " Format json
  map <leader>j :!cat % \| json_pp \| tee %<cr><cr>
  " Format javascript with prettier
  nnoremap <cr> :Neoformat<cr>
  let g:neoformat_run_all_formatters = 1

  let g:neoformat_graphql_prettier = {
              \ 'exe': 'prettier',
              \ 'args': [],
              \ }
  let g:neoformat_javascript_prettier = {
              \ 'exe': 'prettier',
              \ 'args': ['--single-quote', '--trailing-comma es5', '--config-precedence prefer-file'],
              \ }
  " Toggle fold
  map <leader>f za
  " map <leader>F za
  " Open scratch file
  map <leader>s :e scratch.exs<cr>
  " Run scratch file
  map <leader>r :!elixir scratch.exs<cr>


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

  " Linter: Execute code checks, find mistakes, in the background
  Plug 'w0rp/ale'
  let g:ale_sign_warning = '⚠'
  let g:ale_sign_error = '✋'

  " Friendly navigation
  Plug 'christoomey/vim-tmux-navigator'

  " Git integration
  Plug 'tpope/vim-fugitive'
  " GitHub integration
  Plug 'tpope/vim-rhubarb'

  Plug 'mattn/emmet-vim'

  " Integrate elixir with vim
  Plug 'elixir-lang/vim-elixir'
  Plug 'slashmili/alchemist.vim'
    map <S-i> K
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

  " Vim surround
  Plug 'tpope/vim-surround'

	" Support more . repeat types
	Plug 'tpope/vim-repeat'

  " Change cursor to blinking line when in insert mode
  Plug 'jszakmeister/vim-togglecursor'

  " Reveal file in finder
  Plug 'henrik/vim-reveal-in-finder'

  " Matching pairs
  " Plug 'Raimondi/delimitMate'
  
  " Icons for filetypes
  Plug 'ryanoasis/vim-devicons'

  " Easy motion
  Plug 'easymotion/vim-easymotion'
  map  f <Plug>(easymotion-bd-w)
  map  gl <Plug>(easymotion-bd-jk)

  " Track the engine.
  Plug 'SirVer/ultisnips'
  " Snippets are separated from the engine. Add this if you want them:
  Plug 'honza/vim-snippets'
    let g:UltiSnipsExpandTrigger="<c-e>"
    let g:UltiSnipsListSnippets="<c-tab>"
    " :UltiSnipsEdit splits the window.
    let g:UltiSnipsEditSplit="vertical"
    let g:UltiSnipsSnippetDirectories=["UltiSnips"]


  " Snippets are separated from the engine. Add this if you want them:
  Plug 'honza/vim-snippets'

  " Vim instant markdown
  " Also requires: npm -g install instant-markdown-d
  Plug 'suan/vim-instant-markdown'
    " Requires this is turned on
    filetype plugin on


  " Restore cursor position
  Plug 'dietsche/vim-lastplace'

  " Format on save
  Plug 'sbdchd/neoformat'

  " Save vim sessions
  Plug 'tpope/vim-obsession'

  " Markdown
  Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'

  " Rust fmt
  Plug 'rust-lang/rust.vim'
  " Smart imports for JS modules
  Plug 'Galooshi/vim-import-js'

  " Graphql stuff
  Plug 'jparise/vim-graphql'

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
autocmd FileType * set expandtab
filetype plugin indent on


" Javascript
" autocmd FileType javascript set formatprg=prettier\ --stdin\ --single-quote\ --trailing-comma\ es5
" autocmd BufWritePre *.js Neoformat


function! Format()
  let my_filetype = &filetype
  Neoformat
  " if my_filetype =~ 'javascript'
  "   Neoformat
  " else if my_filetype =~ 'graphql'
  "   Neoformat
  " else if my_filetype =~ 'json'
  "   Neoformat
  " else if my_filetype =~ 'css'
  "   Neoformat
  " else
  "   normal! ggVG=<c-o><c-o>
  " endif
endfunction
