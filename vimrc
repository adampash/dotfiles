let mapleader = ","
set shell=/bin/bash

set nocompatible  " Use Vim settings, rather then Vi settings
set nobackup
set nowritebackup
" http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set noswapfile
set modelines=0
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set backspace=indent,eol,start
set hlsearch
set undofile
set scrolloff=3
set visualbell "turn off beeps
set cursorline
set colorcolumn=85
set wildmenu
set wildmode=list:full

" Save on losing focus
au FocusLost * :wa


"search for lowercase string will be case-insensitive
"if one or more characters is uppercase the search will be case-sensitive
set ignorecase
set smartcase

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

"clear the search buffer when hitting return or esc
augroup no_highlight
  autocmd TermResponse * nnoremap <esc> :noh<return><esc>
augroup END

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

filetype plugin indent on " Enable filetype-specific indenting and plugins

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass 

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
augroup END

augroup filetypedetect
  au! BufRead,BufNewFile *_spec.rb set filetype=rspec.ruby
augroup END

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1

" Set UltiSnips to use vim-snippets
let g:UltiSnipsSnippetsDir=["bundle/vim-snippets/snippets"]
let g:always_use_first_snippet=1 "use first


" Numbers
set relativenumber
set nu
set numberwidth=5

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

"Rename Current File
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>l :PromoteToLet<cr>


" Tab completion
" " will insert tab at beginning of line, will use completion if not at beginning
set wildmode=list:longest,list:full
set complete=.,w,t
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>

" Remove trailing whitespace on save for ruby files.
au BufWritePre *.rb :%s/\s\+$//e

" Display extra whitespace
set list listchars=tab:»·,trail:·

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" " Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Close all other windows, open a vertical split, and open this file's test
" " alternate in it.
nnoremap <leader>s :call FocusOnFile()<cr>
function! FocusOnFile()
  tabnew %
  normal! v
  normal! l
  call OpenTestAlternate()
  normal! h
endfunction
" Reload in chrome
map <leader>l :w\|:silent !reload-chrome<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.e\?rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>.  :call OpenTestAlternate()<cr>


" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :w\|:VroomRunTestFile<cr>
map <leader>y :w\|:VroomRunNearestTest<cr>
map <Leader>rr :w\|:!rspec --color %<cr>
imap <Leader>rr <ESC> :w\|:!rspec --color %<cr>
let g:vroom_map_keys = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 cnoremap %% <C-R>=expand('%:h').'/'<cr>
 map <leader>e :edit %%

"""""""""""""""""""
"Random Key Mappings
"""""""""""""""""""

"make shift-tab unindent
nmap <S-Tab> <<
imap <S-Tab> <Esc><<i


"Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Jump into ex mode with space
nnoremap <space> :
map <Leader>bb :!bundle install<CR>
map <Leader>cu :!cucumber<CR>
map <Leader>gc :Gcommit<CR>
map <Leader>gd :Gdiff<CR>
map <Leader>gi :Git
map <Leader>gs :Gstatus<CR>
map <Leader>grm :Gremove
map <Leader>i mmgg=G`m<CR>:w<CR>
map <Leader>h noh<CR>
map <Leader>m :Rmodel<CR>
map <Leader>pn :sp ~/Dropbox/notes/programing_notes.txt<cr>
map <Leader>ra :%s/
map <Leader>rw :%s/\<<C-r><C-w>\>/
map <Leader>vi :tabe ~/Dropbox/dotfiles/vimrc<CR>
map <Leader>vu :RVunittest<CR>
map <Leader>vm :RVmodel<cr>
map <Leader>vv :RVview<cr>
map <Leader>vc :RVcontroller<cr>
map <Leader>vf :RVfunctional<cr>
nnoremap <C-e> 3<C-e> " make ^e scroll 3 lines

nnoremap <leader>w :w!<cr>

" ctrl-s write
nnoremap <c-s> :w<cr>

" Yank selected text to clipboard
vnoremap <C-c> "*y
"Yank entire file
map <Leader>ca ggVG"*y

"Paste clipcoard
map <Leader>vv "*p


imap <C-j> (
imap <C-k> )

command! Q q " Bind :Q to :q
command! Q q " Bind :Q to :q
command! WQ wq
command! Wq wq
command! W w
command! Vsp vsp
command! Vs vsp
command! Sp sp
command! Xa xa
