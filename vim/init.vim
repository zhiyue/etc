"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plain things that (almost) everybody would agree.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enable vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plug 'ervandew/supertab'
Plug 'fatih/vim-go'
Plug 'hdima/python-syntax'
Plug 'hynek/vim-python-pep8-indent'
Plug 'junegunn/vim-emoji'
Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdtree'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-surround'
Plug 'Valloric/YouCompleteMe', {'do': './install.py'}
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/AutoClose'
Plug 'xiaket/better-header'
call plug#end()

" encoding and formats.
set fileencodings=utf-8,gbk,ucs-bom,cp936
set ffs=unix,dos,mac
" Do not redraw while running macros (much faster).
set lazyredraw
" Search related.
set noignorecase
set showmatch
" Tab and indent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
autocmd FileType make set noexpandtab shiftwidth=8
" Enable folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za
vnoremap <space> zf
" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=3
" always report number of lines affected.
set report=0
"Wrap lines
set wrap
" backup and swap file
set backup
set backupdir=~/.vim/backup
set nowb
set noswapfile
" save undo history
set undofile
set undodir=~/.vim/undo
" Auto save and load view (folding, position, but not options)
" saving options would sometime incorrectly set noexpandtab in 
" python source files.
set viewoptions-=options
autocmd BufWinLeave ?* mkview
autocmd BufWinEnter ?* silent loadview
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" End of Plain things.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start of magic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enable tomorrow colorscheme
colorscheme Tomorrow-Night-Eighties

" Statusline
hi StatusLine ctermbg=Black ctermfg=White
set statusline=%y[%l-%L,%v][%p%%][%{&fileencoding},%{&fileformat}]\ %F%m%r\ %h
let g:airline_theme='tomorrow'

" YouCompleteMe
func! s:jInYCM()
    if pumvisible()
        return "\<C-n>"
    else
        return "\<c-j>"
endfunction

func! s:kInYCM()
    if pumvisible()
        return "\<C-p>"
    else
        return "\<c-k>"
endfunction

inoremap <c-j> <c-r>=g:jInYCM()<cr>
au BufEnter,BufRead * exec "inoremap <silent> " . g:UltiSnipsJumpBackwardTrigger . " <C-R>=g:kInYCM()<cr>"

" UltiSnip key mappings.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" Change cursor shape in insert: only work in iTerm2.
let &t_SI = "\<Esc>]50;CursorShape=1\x7" 
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" UltiSnip settings.
let g:UltiSnipsSnippetDirectories=["/Users/xiaket/.vim/UltiSnips"]
let g:UltiSnipsDoHash=0

" mappings
"Paste toggle - don't indent during pasting.
set pastetoggle=<F3>
" use NERDTree
nnoremap <F4> :NERDTree<cr>
"Remove trailing spaces
map <silent> <F5> :%s/\s*$//g<cr>
" In case of Q! and WQ, as I have to press Shift.
cmap Q! q!
cmap WQ wq
cmap Wq wq

" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" case sensible when doing completion
set infercase

" auto save on bufleave and lose focus.
autocmd BufLeave,FocusLost * silent! wall

" Smart line number
function RelativeLineNumber(target)
    if !exists("b:lnstatus")
        let b:lnstatus = "number"
    endif
    if b:lnstatus != "nonumber"
        if a:target == "number"
            set number
            set norelativenumber
        else
            set number
            set relativenumber
        endif
    else
        set nonumber
    endif
endfunction

function ToggleLineNumber()
    if !exists("b:lnstatus")
        let b:lnstatus = "number"
    endif
    if b:lnstatus == "number"
        set nonumber
        set norelativenumber
        let b:lnstatus = "nonumber"
    else
        set number
        set relativenumber
        let b:lnstatus = "number"
    endif
endfunction

" relative line number
autocmd InsertEnter * :call RelativeLineNumber("number")
autocmd InsertLeave * :call RelativeLineNumber("relativenumber")
autocmd FocusLost * :call RelativeLineNumber("number")
autocmd CursorMoved * :call RelativeLineNumber("relativenumber")
nnoremap <F2> :call ToggleLineNumber()<cr>

let g:BHAUTHOR = 'Xia Kai <xiaket@corp.netease.com/xiaket@gmail.com>'
let g:BHUnder = ['~/.xiaket/share/Dropbox/git', '~/.xiaket/share/repos/gitlab', '~/.xiaket/share/repos/github']
let g:BHExcludeDir = ["~/.xiaket/share/repos/gitlab/Python/cbrc-core"]
let g:BHDebug = "0"

" NERD configurations
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeIgnore = ['\.pyc$']

silent! if emoji#available()
  let g:gitgutter_sign_added = emoji#for('small_blue_diamond')
  let g:gitgutter_sign_modified = emoji#for('small_orange_diamond')
  let g:gitgutter_sign_removed = emoji#for('small_red_triangle')
  let g:gitgutter_sign_modified_removed = emoji#for('collision')
endif
