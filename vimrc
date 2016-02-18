""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Maintainer:   Daniel Hamilton
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" --------------------------------------------------------------------------
" Basic Editor settings
" --------------------------------------------------------------------------

filetype on         " Automatic file type detection

set showcmd         " Display incomplete commands
set showmatch       " Show matching brackets.
set tabstop=4       " Number of spaces diplayed for a tab
set softtabstop=4   " How many columns are used for tab in insert mode
set shiftwidth=4    " Spaces for autoindents
set expandtab       " Turn tabs into spaces
set number          " Always show line numbers
set nowrap          " Deactivate wrapping
set textwidth=75    " Text auto breaks after 75 characters
set modeline        " Enable modeline

set wildmenu        " Show zsh like menu for tab autocompletes
set ruler           " Show the cursor position all the time
set laststatus=2    " Use 2 lines for the status bar
set showmode        " Show the mode in the status bar (insert/replace...)
set clipboard=unnamed " y and p copy/paste interaction with OS X clipboard

set notitle         " Do not show filename in terminal titlebar
set backspace=indent,eol,start " Backspacing over everything in insert mode
set whichwrap+=>,l  " At the end of a line move to beggining of the next
                    " when moving the cursor
set whichwrap+=<,h  " At the start of a line move to end of the previous
                    " when moving the cursor
set scrolloff=5     " Keep at least 5 lines above/below the cursor

set autoread        " Watch for file changes by other programs
set autowrite       " Write current buffer when running :make
set smarttab        " Make <tab> and <backspace> smarter
set noignorecase    " Don't ignore case in searches
set esckeys         " Map missed escape sequences (enables keypad keys)
set autoindent      " Turn on autoindent
set smartindent     " Turn on smartindent

set undolevels=1000 " set max number of changes that can be undone
set updatecount=50  " set chars before vim writes recovery swapfile to disk
set history=1000    " Number of commands to remember
set hidden          " Opening a new file when the current buffer has unsaved
                    " changes causes the current file to be hidden instead
                    " of closed
set confirm         " Get a dialog when :q, :w, :wq etc fails
set incsearch       " Do incremental searching
set undofile        " Keep an undo file (undo changes after closing)
set backup          " Keep backup files

" Enable persistent undo, and put undo files in their own directory to
" prevent pollution of project directories
if exists("+undofile")
    " Create the directory if it doesn't exists
    if isdirectory($HOME . '/.vim/undo') == 0
        :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
    endif
    " Remove current directory and home directory, then add .vim/undo as
    " main dir and current dir as backup dir
    set undodir-=.
    set undodir-=~/
    set undodir+=.
    set undodir^=~/.vim/undo//
    set undofile
endif

" Set a common location for storing backup files
if exists("+backup")
    " Create the directory if it doesn't exists
    if isdirectory($HOME . '/.vim/backup') == 0
        :silent !mkdir -p ~/.vim/backup > /dev/null 2>&1
    endif
    " Remove current directory and home directory, then add .vim/backup as
    " main dir and current dir as backup dir
    set backupdir-=.
    set backupdir-=~/
    set backupdir+=.
    set backupdir^=~/.vim/backup//
    set backup
endif

" Configure the location for storing temporary swap files creating if
" required
if isdirectory($HOME . '/.vim/swap') == 0
    :silent !mkdir -p ~/.vim/swap > /dev/null 2>&1
endif
" Set the dir, falling back to /var/tmp in case the above failed
set dir=~/.vim/swap,/var/tmp

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif


" --------------------------------------------------------------------------
" User commands
" --------------------------------------------------------------------------

" Don't use Ex mode, use Q for formatting
map Q gq

" Faster scrolling using ctrl
map <C-j> 5j
map <C-k> 5k
map <C-h> 5h
map <C-l> 5l

" Paste mode toggle. Helps avoid unexpected effects when pasting into vim
map <C-p> :set invpaste<CR>

" Show line numbers toggle
map <C-n> :set invnumber<CR>

" Y should have the same behaviour as D e.g. yank to end, but instead works
" like yy. Fix here:
map Y y$

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

  " smartindent:
  " By default When typing '#' as the first character in a new line, the
  " indent for that line is removed and the '#' is put in the first column.
  " If you don't want this, use this mapping:
  "
  " :inoremap # X^H#
  "
  " where ^H is entered with CTRL-V CTRL-H.
  " When using the '>>' command, lines starting with '#' are not shifted
  " right.
  autocmd FileType python,php,vim inoremap # X#

else

  set autoindent        " Always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and
" the file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif


" --------------------------------------------------------------------------
" Plugins settings
" --------------------------------------------------------------------------

" Pathogen
" https://github.com/tpope/vim-pathogen
"
" Manage your 'runtimepath' with ease. In practical terms, pathogen.vim
" makes it super easy to install plugins and runtime files in their own
" private directories.
" All plugins extracted to a subdirectory under ~/.vim/bundle will be added to
" the 'runtimepath' automatically
call pathogen#infect()      " Load Pathogen Plugins
call pathogen#helptags()    " Generate documentation for Plugins

" Automatically managed plugins:
"
" vim-irblack
"       - https://github.com/wesgibbs/vim-irblack.git
"       - This is a version of Infinite Red's vim theme:
"         (http://blog.infinitered.com/entries/show/8) packaged to work
"         with Tim Pope's pathogen plugin
"       - The main theme must be loaded first so that all other plugins
"         that set some form of highlighting can take effect
"
" Set the theme
colorscheme ir_black
" Let vim know we are using a dark console/transparent with dark background
set background=dark
"
" jedi-vim:
"       - https://github.com/davidhalter/jedi-vim
"       - Awesome Python autocompletion with VIM
"       - Required jedi to be installed from macports or recursive clone
"         of the jedi-vim repo (includes jedi)
"

" vim-better-whitespace:
"       - https://github.com/ntpeters/vim-better-whitespace.git
"       - This plugin causes all trailing whitespace characters (spaces and
"         tabs) to be highlighted. Whitespace for the current line will not
"         be highlighted while in insert mode.
"       - A helper function :StripWhitespace is also provided to make
"         whitespace cleaning painless.
"
" Set to auto strip trailing whitespace on file save
autocmd BufWritePre * StripWhitespace
"

" syntastic:
"       - https://github.com/scrooloose/syntastic.git
"       - Syntastic is a syntax checking plugin for Vim that runs files
"         through external syntax checkers and displays any resulting
"         errors to the user.
"
" Fill the error location-list with errors found by the checkers
let g:syntastic_always_populate_loc_list = 1
" Allow auto open/close of the error window
let g:syntastic_auto_loc_list = 1
" Whether to invoke checkers when the file is opened
let g:syntastic_check_on_open = 0
" Whether to invoke checkers when we write/quit
let g:syntastic_check_on_wq = 0
"


" --------------------------------------------------------------------------
" Local overrides of main Vim Theme
" --------------------------------------------------------------------------

" Main theme 'ir-black' is loaded by pathogen: see above

" vim-better-whitespace
" Set to highlight whitespace in green rather than the default red
hi ExtraWhitespace ctermbg=green


" Set a custom highlight group for use with the statusline
if &t_Co>2 && &t_Co<=16
    " For basic color terminals
    hi User1 ctermbg=grey ctermfg=green guibg=grey guifg=green
    hi User2 ctermbg=grey ctermfg=blue  guibg=grey guifg=blue
    hi User3 ctermbg=grey ctermfg=red   guibg=grey guifg=red
elseif &t_Co>16
    " For terminals with 256 color support
    hi User1 ctermbg=235 ctermfg=208 guibg=235 guifg=208
    hi User2 ctermbg=235 ctermfg=27  guibg=235 guifg=27
    hi User3 ctermbg=235 ctermfg=160 guibg=235 guifg=196
endif

" Now create the status line
set statusline=                                 " Clear default statusline
set statusline+=%1*%t\                          " Tail of the filename
set statusline+=%2*[%3.3n]                      " Buffer number
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, " File encoding
set statusline+=%{&ff}]                         " File format
set statusline+=%h                              " Help file flag
set statusline+=%3*%m                           " Modified flag
set statusline+=%r                              " Read only flag
set statusline+=%2*%y                           " Filetype
set statusline+=%=                              " Left/right separator
set statusline+=%c,                             " Cursor column
set statusline+=%l/%L                           " Cursor line/total lines
set statusline+=\ %P                            " Percent through file
set statusline+=%#warningmsg#                   " Syntastic warning messages
set statusline+=%{SyntasticStatuslineFlag()}    " Syntastic status
set statusline+=%*                              " Syntastic status
