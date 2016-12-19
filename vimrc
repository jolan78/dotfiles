"------------------------------------------------------------
" Features {{{1
"
" These options and commands enable some very useful features in Vim, that
" no user should have to live without.

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Attempt to determine the type of a file based on its name and possibly its
" contents.  Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Enable syntax highlighting
syntax on

" highlight cursor line
set cursorline

"------------------------------------------------------------
" Must have options {{{1
"
" These are highly recommended options.

" One of the most important options to activate. Allows you to switch from an
" unsaved buffer without saving it first. Also allows you to keep an undo
" history for multiple files. Vim will complain if you try to quit without
" saving, and swap files will keep you safe if your computer crashes.
set hidden

" Better command-line completion
set wildmenu
" set wildmode=list:longest " turn on wild mode huge list
" ignore these list file extensions
" set wildignore=*.dll,*.o,*.obj

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Search and show matches as you type
set incsearch
 
" Modelines have historically been a source of security vulnerabilities.  As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline

set backup " make backup files
if !isdirectory($HOME."/.vim_backup/")
    call mkdir($HOME.'/.vim_backup')
endif
set backupdir=$HOME/.vim_backup " where to put backup files
if !isdirectory($HOME.'/.vim_swp/')
    call mkdir($HOME.'/.vim_swp')
endif
set directory=$HOME/.vim_swp " directory to place swap files in

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup
au BufWrite /etc/pw.* set nowritebackup

"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
" set autoindent

" more configurable than autoindent
set cindent
" {1s : one shiftwidth at brace
" f1s : one shiftwidth at block
set cinoptions={1s,f1s

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell.  If visualbell is set, and
" this line is also included, vim will neither flash nor beep.  If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

" better completion menu :
" longest : write only longest common match
" menuone : display the menu even if one match
" preview : prototype in scratch (default)
set completeopt=longest,menuone,preview

" enter = select menu entry (instead of CR)
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.

" Indentation settings for using 2 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
" set shiftwidth=2
" set softtabstop=2
" set expandtab

" Indentation settings for using hard tabs for indent. Display tabs as
" two characters wide.
set shiftwidth=2
set tabstop=2


"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
" map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" Map <C-@> to <C-]> (jump to tag in vim help) because it's not avail.
nnoremap <C-@> <C-]>

"------------------------------------------------------------
" PHP option {{{1

" indent the '{' and '}' at the same
" level than the code they contain.
let PHP_BracesAtCodeLevel = 1

" Set PHP file extensions
au BufNewFile,BufRead *.php              setf php.html

"  highlights interpolated variables in sql strings and does sql-syntax highlighting. yay
autocmd FileType php let php_sql_query=1
" does exactly that. highlights html inside of php strings
autocmd FileType php let php_htmlInStrings=1
" discourages use of short tags. c'mon its deprecated remember
autocmd FileType php let php_noShortTags=0
" automagically folds functions & methods. this is getting IDE-like isn't it?
autocmd FileType php let php_folding=1
autocmd FileType php set iskeyword+=_,$" none of these are word dividers

autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP

" PIV incorrectly set php functions as Identifier's
hi def link phpFunctions        Function

"------------------------------------------------------------
" Candy option {{{1
if $SSHUSER_HOME != ""
	set runtimepath+=$SSHUSER_HOME/.vim/
endif

set list " we do what to show tabs etc
set listchars=tab:\ \ ,trail:.
set nostartofline " leave my cursor where it was
set showmatch " show matching brackets when inserting

function! SLReadOnly()
	if(&ro)
		return '✗'
	else
		return ''
	endif
endf
set statusline=%<%F\ %m%#Error#%{SLReadOnly()}%#StatusLine#%=C:%b/0x%B\ %l,%c\ %P%h\ %y[%{&fenc}/%{&ff}]

" c : Auto-wrap comments using textwidth, inserting the current comment leader
" automatically.
set formatoptions+=c

"------------------------------------------------------------
" Vundle option {{{1
" check if Vundle is installed
if $SSHUSER_HOME == ""
	echo "SSHUSER_HOME n'est pas défini."
	echo "executez ceci pour l'ajouter à .bashrc"
	echo "echo 'export VIMINIT=\"let \\\$SSHUSER_HOME=\\\"$HOME\\\" | so \$HOME/.vimrc | let \\\$MYVIMRC = \\\"$HOME/.vimrc\\\"\"' >> ~/.bashrc"
	finish
endif
if !isdirectory($SSHUSER_HOME.'/.vim/bundle/')
  call mkdir($SSHUSER_HOME.'/.vim/bundle/','p')
endif
if !isdirectory($SSHUSER_HOME."/.vim/bundle/Vundle.vim")
  echo "installing Vundle..."
  try
		!git clone https://github.com/VundleVim/Vundle.vim.git $SSHUSER_HOME/.vim/bundle/Vundle.vim
    if v:shell_error
      echo "exiting"
      quit
    endif
  catch
    echo "error !"
    quit
  endtry
endif

" tell Vim where to find the autoload function:
set runtimepath+=$SSHUSER_HOME/.vim/bundle/Vundle.vim

call vundle#begin($SSHUSER_HOME.'/.vim/bundle')


	Plugin 'indentpython.vim'
" let Vundle manage Vundle, required
	Plugin 'VundleVim/Vundle.vim'

	Plugin 'elzr/vim-json'
	Plugin 'scrooloose/nerdtree'
	Plugin 'Maxlufs/LargeFile.vim'
	" size in MB
	let g:LargeFile=5

	Plugin 'vim-scripts/YankRing.vim'
	Plugin 'spf13/PIV'
	Plugin 'ervandew/supertab'
	" CR selects current entry in popup (instead of inserting actual CR)
	let g:SuperTabCrMapping=0
	let g:SuperTabDefaultCompletionType = "context"
	let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"

	Plugin 'tomtom/quickfixsigns_vim'
	let g:quickfixsigns_classes = [ 'qfl', 'loc', 'marks', 'vcsdiff']
	sign define QFS_QFL text=* texthl=WarningMsg linehl=WarningMsg_Bg
	sign define QFS_LOC text=> texthl=Special linehl=Special_Bg

	Plugin 'jolan78/checksyntax_vim'
	let g:checksyntax#lines_expr = 'min([len(getloclist(0)),10])'

	Plugin 'jolan78/iTerm2Yank'
	Plugin 'altercation/vim-colors-solarized'
	Plugin 'Raimondi/delimitMate'
	" workaround for delimitMate breaking ESC (not anymore ?) :
	"set timeout
	
	"load this on demand only
	"Plugin 'joonty/vdebug'

	" deactivated plugins
	"'swap_parameters' -> requires python
call vundle#end()

"------------------------------------------------------------
" solarized option {{{1
let g:solarized_termcolors=256
syntax enable
set background=dark
colorscheme solarized
" change function color to yellow
hi Function cterm=bold ctermfg=136

