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
" with php, syntax enable + foldmethod=syntax is really slow
syntax enable


"--------------------------------------------------------
" Paths {{{1
"
let s:configroot = expand('<sfile>:p:h')

let &runtimepath = &runtimepath.','.s:configroot.'/.vim/'

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
autocmd BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
autocmd BufWrite /private/etc/pw.* set nowritebackup
autocmd BufWrite /etc/pw.* set nowritebackup

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

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

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
set nomodeline


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
" set cmdheight=2
" height = 1 works with noshowmode
set cmdheight=1

" do not show --MODE--
set noshowmode

" Display line numbers on the left
set number

" display line number at current line, and relative numbers at other lines
set relativenumber

" keep 3 lines above/below when scrolling
set scrolloff=3

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

" highlight code blocks in markdown
let g:markdown_fenced_languages = ['html', 'css', 'scss', 'sql', 'javascript', 'go', 'python', 'bash=sh', 'c', 'ruby','php']
let g:markdown_syntax_conceal = 1

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

let mapleader = ","

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
" map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR>::syntax sync fromstart<CR><C-L>

" Map <C-@> to <C-]> (jump to tag in vim help) because it's not avail.
nnoremap <C-@> <C-]>

" cd to the current file's dir
cmap cd. lcd %:p:h

"------------------------------------------------------------
" PHP option {{{1

" indent the '{' and '}' at the same
" level than the code they contain.
let PHP_BracesAtCodeLevel = 1
"  highlights interpolated variables in sql strings and does sql-syntax highlighting. yay
let php_sql_query=1
" does exactly that. highlights html inside of php strings
let php_htmlInStrings=1
" discourages use of short tags. c'mon its deprecated remember
let php_noShortTags=0

augroup php_conf
	autocmd!
	autocmd FileType php setlocal iskeyword+=_,$" none of these are word dividers

	autocmd FileType php setlocal tabstop=4 shiftwidth=4 noexpandtab

	" Set PHP file extensions
	"autocmd BufNewFile,BufRead *.php              setf php.html

	" automagically folds functions & methods. this is getting IDE-like isn't it?
	" this is really slow :
	"let php_folding=1
	" workaround : fold on indent and start with all folds open
	autocmd FileType php setlocal foldmethod=indent
	autocmd FileType php setlocal foldlevel=99
augroup END

"------------------------------------------------------------
" PIV / phpcomplete.vim options {{{2

" not working :
let g:phpcomplete_mappings = {
			\ 'jump_to_def': ',g',
			\ 'jump_to_def_tabnew': ',t',
			\ }
let g:phpcomplete_parse_docblock_comments = 1

"------------------------------------------------------------
" Completion : omni examples {{{1

"autocmd FileType php setl ofu=phpcomplete#CompletePHP
"autocmd FileType ruby,eruby setl ofu=rubycomplete#Complete
"autocmd FileType html,xhtml setl ofu=htmlcomplete#CompleteTags
"autocmd FileType css setl ofu=csscomplete#CompleteCSS
"autocmd FileType c setl ofu=ccomplete#CompleteCpp
"autocmd FileType python setl ofu=pythoncomplete#Complete
"autocmd FileType javascript setl ofu=javascriptcomplete#CompleteJS


"------------------------------------------------------------
" Candy option {{{1

set list " we do what to show tabs etc
set listchars=tab:\ \ ,trail:.
set nostartofline " leave my cursor where it was
set showmatch " show matching brackets when inserting

" c : Auto-wrap comments using textwidth, inserting the current comment leader
" automatically.
set formatoptions+=c

" highlight cursor line
set cursorline

"------------------------------------------------------------
" Plugins {{{1
"
" Plugin manager init & auto-install {{{2

"if $SSHUSER_HOME == ""
"	echo "SSHUSER_HOME n'est pas défini."
"	echo "executez ceci pour l'ajouter à .bashrc"
"	echo "echo 'export VIMINIT=\"let \\\$SSHUSER_HOME=\\\"$HOME\\\" | so \$HOME/.vimrc | let \\\$MYVIMRC = \\\"$HOME/.vimrc\\\"\"' >> ~/.bashrc"
"	finish
"endif
if !isdirectory(s:configroot.'/.vim/plugged/')
  call mkdir(s:configroot.'/.vim/plugged/','p')
endif
if !filereadable(s:configroot."/.vim/autoload/plug.vim")
  echo "installing vim-plug..."
  try
	  exe "!curl -fLo ".s:configroot."/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    if v:shell_error
      echo "exiting"
      quit
    endif
  catch
    echo "error !"
    quit
  endtry
endif


call plug#begin(s:configroot.'/.vim/plugged')


	"----------------------------------------
	" Language-specific plugins {{{2
	Plug 'othree/html5.vim'
	Plug 'elzr/vim-json',{'for':'json'}
	Plug 'posva/vim-vue',{'for':['vue','js','php','php.html']}
	Plug 'vim-scripts/indentpython.vim',{'for':'py'}

	"Plug 'lvht/phpcd.vim', { 'for': ['php','php.html']}
	"Plugin 'spf13/PIV'
	"Plugin 'shawncplus/phpcomplete.vim'

	"load this on demand only with :PlugStatus then L
	Plug 'joonty/vdebug',{'for':[]}

	" more up to date php; allow folding and sql/html in php
	Plug 'StanAngeloff/php.vim'
	" available in stock vim, but brace at code level is broken since 3db7a43
	"Plug '2072/PHP-Indenting-for-VIm', {'commit':'1d33045'}
	Plug '2072/PHP-Indenting-for-VIm'
	if (has("patch-8.0.1453"))
		Plug 'fatih/vim-go',{'for':'go'}
	endif

	"----------------------------------------
	" LSP plugins {{{2
	
	"Plug 'neoclide/coc.nvim', {'branch': 'release'}

	Plug 'dense-analysis/ale'

	" vim-lsp depends on ascync on vim8
	"Plug 'prabirshrestha/async.vim'
	"Plug 'prabirshrestha/vim-lsp'
	" provides :LspInstall
	"Plug 'mattn/vim-lsp-settings'

	" vim-lsp rely on ascynccomplete for autocompletion
	"Plug 'prabirshrestha/asyncomplete.vim'
	"Plug 'prabirshrestha/asyncomplete-lsp.vim'
	
	" Viewer & Finder for LSP symbols and tags
	" invoke with :Vista vim-lsp (or another lsp plugin)
	" deactivated because it complains if ctags is not installed
	"Plug 'liuchengxu/vista.vim'

	" Others {{{3
	"Plug 'neomake/neomake'

	"----------------------------------------
	" UI Plugins {{{2
	Plug 'scrooloose/nerdtree'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	Plug 'tomtom/quickfixsigns_vim'
		let g:quickfixsigns_classes = [ 'qfl', 'loc', 'marks', 'vcsdiff']
		"sign define QFS_QFL text=* texthl=WarningMsg linehl=WarningMsg_Bg
		"sign define QFS_LOC text=> texthl=Special linehl=Special_Bg
		"
	" sidebar w/ registers when pasting
	Plug 'junegunn/vim-peekaboo'

	Plug 'altercation/vim-colors-solarized'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	" :UndotreeToggle pour afficher
	Plug 'mbbill/undotree'
	" colorize indent guides
	Plug 'nathanaelkane/vim-indent-guides'
	" Better whitespace highlighting for Vim (red tailing sp.)
	Plug 'ntpeters/vim-better-whitespace'
	" enable zooming in/out with <C-w>o
	Plug 'troydm/zoomwintab.vim'
	" add icons to nerdtree, airline etc.
	Plug 'ryanoasis/vim-devicons'
	" per window search. enable with ,/
	Plug 'mox-mox/vim-localsearch'

	"----------------------------------------
	" Usability {{{2
	Plug 'machakann/vim-highlightedyank'

	Plug 'vim-scripts/YankRing.vim'
	let g:yankring_window_use_horiz = 0 

	if(!exists("g:plugs['coc.nvim']"))
		Plug 'ervandew/supertab'
			" CR selects current entry in popup (instead of inserting actual CR)
			let g:SuperTabCrMapping=0
			let g:SuperTabDefaultCompletionType = "context"
			let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
	endif
	Plug 'jolan78/iTerm2Yank'

	" auto-completion for quotes, parens, brackets, etc.
	"Plug 'Raimondi/delimitMate'
	" breaks '.' repeat until vim 7.4.849

	" like delimitmate. default mappings for advanced fns conflicts macos alt chars
	" fast frap next word in pairs
	let g:AutoPairsShortcutFastWrap='<C-f>'
	autocmd FileType vim let b:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'", '`':'`'}
	Plug 'jiangmiao/auto-pairs'

	" extended % matching for HTML, LaTeX, and many other languages
	Plug 'vim-scripts/matchit.zip'
	" Underlines the word under the cursor
	Plug 'itchyny/vim-cursorword'
	if (has("patch-7.4-1578"))
		"physics-based smooth scrolling
		Plug 'yuttie/comfortable-motion.vim'
	endif

	" display fn doc. coc implements it
	if (has("patch-7.4-774") && !exists("g:plugs['coc.nvim']"))
		Plug 'Shougo/echodoc.vim'
	endif

	"----------------------------------------
	" Generic plugins {{{2
	Plug 'Maxlufs/LargeFile.vim'
		" size in MB
		let g:LargeFile=5

	" Vim script for text filtering and alignment (:Tabularize)
	Plug 'godlygeek/tabular'

	" change args position . use :SidewaysRight
	Plug 'AndrewRadev/sideways.vim'

	if executable('ag')
		let g:ackprg = 'ag --vimgrep'
		" :Ack pour chercher
		Plug 'mileszs/ack.vim'
	endif

	" Use :Grepper to open a prompt
	Plug 'mhinz/vim-grepper'

	" auto set paste on fast input for old vims
	" breaks delimitmate
	if (!has("patch-8.0-0210"))
		" breaks auto-pairs if too fast
		"Plug 'roxma/vim-paste-easy'
	endif

	" secure alternative to modeline
	" see https://www.vim.org/scripts/script.php?script_id=1876
	Plug 'ciaranm/securemodelines'

	"----------------------------------------
	" Disabled plugins {{{2

	" Heuristically set buffer options
	" Plugin 'tpope/vim-sleuth'

	"'swap_parameters' -> requires python

	" interactoive shell interpreter (requires psysh)
	" Plug 'metakirby5/codi.vim'
	"
	"Plugin 'ConradIrwin/vim-bracketed-paste'




	" usefull for statusline
	"Plugin 'rafi/vim-badge'

	" Smart selection of the closest text object (enter/BS in normal mode)
	"Plug 'gcmt/wildfire.vim'



"	Plugin 'vim-php/tagbar-phpctags.vim'
"	let g:tagbar_ctags_bin = 'phpctags'
"	Plugin 'majutsushi/tagbar'

" easytags
"let g:easytags_cmd = '/Users/joseph/bin/phpctags'
"	Plugin 'xolox/vim-misc'
"	Plugin 'xolox/vim-easytags'
	call plug#end()

"-----------------------------------------------------------
" Plugins configuration {{{1

"-----------------------------------------------------------
try
	" neomake {{{2
	if(exists("g:plugs['neomake']"))
		" open list and preserve cursor position
		let g:neomake_open_list = 2
		" when writing, reading or after change in normal/insert mode : 500ms delay
		if (has('timers'))
			call neomake#configure#automake('nrwi', 500)
		else
			call neomake#configure#automake('rw', 0)
			autocmd neomake_automake InsertLeave,CursorHold * call neomake#configure#automake()
		endif

		" only php -l
		let g:neomake_php_enabled_makers = ['php']
	endif

	"-----------------------------------------------------------
	" NERDTree {{{2
	if(exists("g:plugs['nerdtree']"))
		autocmd StdinReadPre * let s:std_in=1
		" open NERDTree if no file
		autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
		" open NERDTree if directory is specified
		autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
		" close vim if the only window left open is a NERDTree
		"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
		function! NERDTreeQuit()
			" vim is still starting
			if (!v:vim_did_enter)
				return
			endif
			redir => buffersoutput
			silent buffers
			redir END
			"                    1BufNo  2Mods.     3File         4LineNo
			let pattern = '^\s*\(\d\+\)\(.....\) "\(.*\)"\s\+.* \(\d\+\)$'
			let windowfound = 0

			for bline in split(buffersoutput, "\n")
				let m = matchlist(bline, pattern)
				if (len(m) > 0)
					"           active mofifiable,    running job,       modified
					if (m[2] =~ '..a[^-].' || m[2] =~ '...R.' || m[2] =~ '....\\+')
						let windowfound = 1
					endif
				endif
			endfor

			if (!windowfound)
				quitall
			endif
		endfunction
		autocmd BufEnter * call NERDTreeQuit()

		" vim-nerdtree-syntax-highlight
		let g:NERDTreeFileExtensionHighlightFullName = 1
		let g:NERDTreeExactMatchHighlightFullName = 1
		let g:NERDTreePatternMatchHighlightFullName = 1
		let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
		let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
		let g:NERDTreeExtensionHighlightColor = {} "this line is needed to avoid error
		let g:NERDTreeExtensionHighlightColor['vue']='42b883'

	endif
	"------------------------------------------------------------
	" localsearch {{{2
	if(exists("g:plugs['vim-localsearch']"))
		nmap <leader>/ <Plug>localsearch_toggle
	endif
	"------------------------------------------------------------
	" airline {{{2
	if(exists("g:plugs['vim-airline']"))
		let g:airline_theme='solarized'
		let g:airline_powerline_fonts = 1
		let g:airline#extensions#tabline#enabled = 1
		"let g:airline#extensions#tabline#show_tabs=1
		let g:airline#extensions#tabline#buffer_nr_show =1
		let g:airline#extensions#zoomwintab#enabled = 1
		let g:airline#extensions#whitespace#enabled = 0
		let g:airline#extensions#cursormode#enabled = 1

		let g:cursormode_mode_func = 'mode'
		let g:cursormode_color_map = {
					\ "nlight": '#000000',
					\ "ndark": '#BBBBBB',
					\ "n": g:airline#themes#{g:airline_theme}#palette.normal.airline_a[1],
					\ "i": g:airline#themes#{g:airline_theme}#palette.insert.airline_a[1],
					\ "R": g:airline#themes#{g:airline_theme}#palette.replace.airline_a[1],
					\ "v": g:airline#themes#{g:airline_theme}#palette.visual.airline_a[1],
					\ "V": g:airline#themes#{g:airline_theme}#palette.visual.airline_a[1],
					\ "\<C-V>": g:airline#themes#{g:airline_theme}#palette.visual.airline_a[1]
					\ }

		nmap <leader>- <Plug>AirlineSelectPrevTab
		nmap <leader>+ <Plug>AirlineSelectNextTab
	endif
	"------------------------------------------------------------
	" solarized {{{2
	if(exists("g:plugs['vim-colors-solarized']"))
		let g:solarized_termcolors=256
		" with php, syntax enable + foldmethod=syntax is really slow
		"syntax enable

		set background=dark
		colorscheme solarized
		" change function color to yellow
		hi Function cterm=bold ctermfg=136
		hi PmenuSel ctermbg=white ctermfg=darkblue
	endif

	"------------------------------------------------------------
	" vim-indent-guides {{{2 
	if(exists("g:plugs['vim-indent-guides']"))
		let g:indent_guides_auto_colors = 0
		hi IndentGuidesOdd  ctermbg=234
		hi IndentGuidesEven ctermbg=235
		let g:indent_guides_guide_size=1

		autocmd FileType php IndentGuidesEnable
		let g:echodoc_enable_at_startup = 1
		"autocmd FileType php EchoDocEnable
	endif
	"------------------------------------------------------------
	"  Coc {{{2
	if(exists("g:plugs['coc.nvim']"))
		if executable('npm')
			"let g:airline#extensions#coc#enabled = 1
			let g:coc_config=s:configroot.'/.vim/coc-settings.json'
			let g:coc_data_home=s:configroot.'/.config/coc'
			call coc#add_extension('coc-phpls','coc-json', 'coc-tsserver','coc-html','coc-css','coc-vetur','coc-python','coc-vimlsp')
			nmap <silent> gr <Plug>(coc-references)
			nmap <silent> gd <Plug>(coc-definition)
			nnoremap <silent> K :call <SID>show_documentation()<CR>
			function! s:show_documentation()
				if (index(['vim','help'], &filetype) >= 0)
					execute 'h '.expand('<cword>')
				else
					call CocActionAsync('doHover')
				endif
			endfunction
			" Show all diagnostics.
			nnoremap <silent> ga  :<C-u>CocList diagnostics<cr>
			let g:coc_status_error_sign    = '✗'
			let g:coc_status_warning_sign  = '‼'
			call coc#config('suggest', {
						\ 'autoTrigger': 'none',
						\ 'enablePreview':'true',
						\})
			"		call coc#config('coc.preferences', {
			"			\ 'currentFunctionSymbolAutoUpdate': 'true',
			"		\})
			inoremap <silent><expr> <TAB>
						\ pumvisible() ? "\<C-n>" :
						\ <SID>check_back_space() ? "\<TAB>" :
						\ coc#refresh()
			inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

			function! s:check_back_space() abort
				let col = col('.') - 1
				return !col || getline('.')[col - 1]  =~# '\s'
			endfunction
		else
			echom "npm in not installed."
		endif
	endif

	" vim-lsp {{{2
	if(exists("g:plugs['vim-lsp']"))
		"autocmd User lsp_setup call lsp#register_server({
		"			\ 'name': 'php-language-server',
		"			\ 'cmd': {server_info->['php', expand('/Users/joseph/test/php-language-server/bin/php-language-server.php')]},
		"			\ 'whitelist': ['php'],
		"			\ })
		let g:lsp_diagnostics_echo_cursor = 1

		let g:cursorword=0
		let g:lsp_highlight_references_enabled = 1
		highlight lspReference term=underline cterm=underline  gui=underline

		let g:lsp_signs_error = {'text': '✗'}
		let g:lsp_signs_warning = {'text': '‼'}
		let g:lsp_signs_hint = {'text': 'i'}

		set omnifunc=lsp#complete
		nmap gd <plug>(lsp-definition)
		" yankring nmap gp
		"nmap gp <plug>(lsp-peek-definition)
		nmap gr <plug>(lsp-references)
		nmap gs <plug>(lsp-signature-help)

		autocmd FileType php.lsp-hover set syntax=php
		"autocmd FileType markdown.lsp-hover set syntax=markdown
		nnoremap <silent> K :call <SID>show_documentation()<CR>
		function! s:show_documentation()
			if (index(['vim','help'], &filetype) >= 0)
				execute 'h '.expand('<cword>')
			else
				execute 'LspHover'
			endif
		endfunction
	endif

"------------------------------------------------------------
	"  ALE {{{2
	if(exists("g:plugs['ale']"))
		" These 2 options must be set before loading ALE ??
		"let g:ale_set_balloons=1
		"let g:ale_hover_to_preview=1

		function! s:get_project_root(buffer) abort
			let l:path = ale#path#FindNearestFile(a:buffer, 'composer.json')
			if (!empty(l:path))
				return fnamemodify(l:path, ':h')
			endif

			let l:path = ale#path#FindNearestDirectory(a:buffer, '.git')
			if (!empty(l:path))
				return fnamemodify(l:path, ':h:h')
			endif

			let l:path = ale#path#FindNearestFile(a:buffer, 'index.php')
			if (!empty(l:path))
				return fnamemodify(l:path, ':h')
			endif

			return fnamemodify(bufname(a:buffer), ':p:h')
		endfunction


		call ale#linter#Define('php', {
					\   'name': 'intelephense-php',
					\   'lsp': 'stdio',
					\   'command': '%e '.s:configroot.'/.config/coc/extensions/node_modules/coc-phpls/node_modules/intelephense/lib/intelephense.js --stdio',
					\   'executable': 'node',
					\   'project_root': funcref('s:get_project_root')
					\})
		"let g:ale_completion_enabled=1
		let g:ale_linters = {'php': ['intelephense-php','php']}
		"set omnifunc=ale#completion#OmniFunc
		" stock runtime scripts reset omnifunc
		autocmd FileType * setlocal omnifunc=ale#completion#OmniFunc

		"mappings
		nmap <silent> gd <Plug>(ale_go_to_definition)
		nmap <silent> gD <Plug>(ale_go_to_definition_in_split)
		nmap <silent> gr <Plug>(ale_find_references)
		nnoremap <silent> K :call <SID>show_documentation()<CR>
		function! s:show_documentation()
			if (index(['vim','help'], &filetype) >= 0)
				execute 'h '.expand('<cword>')
			else
				call ale#hover#ShowAtCursor() 
			endif
		endfunction
	 endif
	" PIV {{{2
	if(exists("g:plugs['PIV']"))
		" PIV incorrectly set php functions as Identifier's
		hi def link phpFunctions        Function
	endif
	" vim-vue {{{2
	if(exists("g:plugs['vim-vue']"))
		autocmd BufRead,BufNewFile *.vue		set filetype=vue
	endif
	" vista-vim {{{2
	if(exists("g:plugs['vista-vim']"))
		if(exists("g:plugs['coc.nmvim']"))
			let g:vista_default_executive = 'vim-lsp'
		elseif(exists("g:plugs['vim-lsp']"))
			let g:vista_default_executive = 'vim_lsp'
		elseif(exists("g:plugs['ale']"))
			let g:vista_default_executive = 'ale'
		endif
	endif

" }}}2
catch
	echo "Plugins configuration failed. Maybe One or more plugins is not installed. run :PlugInstall. exception : ".v:exception
endtry
"}}}1

" vim: fdm=marker
