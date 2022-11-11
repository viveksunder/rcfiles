call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive' "requirement from benwainwright/fzf-project
Plug 'benwainwright/fzf-project'
Plug 'ayu-theme/ayu-vim'
Plug 'rakr/vim-one'
Plug 'JuliaEditorSupport/julia-vim'
" Initialize plugin system
call plug#end()

" Themes
"
" 
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

"let ayucolor="light"  " for light version of theme
"let ayucolor="mirage" " for mirage version of theme
"let ayucolor="dark"   " for dark version of theme
colorscheme one
set background=dark

""" End themes

let mapleader = '\'
nnoremap <Leader><Leader> :<C-u>FZF<CR>

" Splits
nmap <silent> <Leader>v :vsplit<CR>
nmap <silent> <Leader>h :split<CR>

"Buffer on
map <silent> <Leader>o :on<CR>

"Write file
map <silent> <Leader>w :w<CR>

"Quit window
map <silent> <Leader>q :q<CR>

"Window nav
map [C <C-Right>
map [D <C-Left>
map [A <C-Up>
map [B <C-Down>
map <silent> <C-Right> :wincmd l<CR>
map <silent> <C-Left> :wincmd h<CR>
map <silent> <C-Up> :wincmd k<CR>
map <silent> <C-Down> :wincmd j<CR>
noremap <silent> <Tab> :bn<CR>


" :noh
map <silent> <Leader>- :noh<CR>

" nu nonu toggle
map <silent> <Leader>l :set nu!<CR>

" FZF Project switcher
map <silent> <Leader>p : FzfSwitchProject<CR>

"FZF Project configuration
"
let g:fzfSwitchProjectWorkspaces = [ '~/Projects' ]

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
runtime macros/matchit.vim "Enable for julia support to move around if/end function/end blocks.
