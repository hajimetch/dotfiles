" =================================================================
" 基本設定 (Basic Settings)
" =================================================================
set fenc=utf-8               " 文字コード
set nobackup                 " バックアップ取らない
set noswapfile               " スワップファイル作らない
set autoread                 " 外部変更の自動読み込み
set hidden                   " バッファ切り替え時に保存を強制しない
set showcmd                  " 入力中のコマンドを表示
set backspace=indent,eol,start " バックスペースの挙動改善
set clipboard^=unnamed       " OSのクリップボードと連携
set lazyredraw               " マクロ実行中などの再描画を抑制（高速化）

" =================================================================
" 見た目・表示 (Visual Settings)
" =================================================================
set number                   " 行番号表示
set cursorline               " 現在行ハイライト
set virtualedit=onemore      " 行末のさらに1文字先へ移動可能に
set showmatch                " 対応する括弧を強調
set laststatus=2             " ステータスラインを常に表示
set wildmode=list:longest    " コマンドライン補完モード
set visualbell t_vb=         " ビープ音を鳴らさない・画面フラッシュもしない
set noerrorbells

" シンタックスとインデントの自動検出（smartindentの代わり）
syntax enable
filetype plugin indent on

" =================================================================
" Tab・インデント (Tab & Indent)
" =================================================================
set list listchars=tab:\▸\-  " 不可視文字の可視化
set expandtab                " Tabをスペースに変換
set tabstop=2                " Tabの表示幅
set shiftwidth=2             " 自動インデントの幅
set softtabstop=2            " キーボードでTabを押した時の幅

" =================================================================
" 検索 (Search)
" =================================================================
set ignorecase               " 大文字小文字を区別しない
set smartcase                " 大文字が含まれる場合のみ区別
set incsearch                " インクリメンタルサーチ
set wrapscan                 " 最後まで検索したら先頭に戻る
set hlsearch                 " 検索結果をハイライト
" ESC連打でハイライト解除
nnoremap <silent> <Esc><Esc> :nohlsearch<CR><Esc>

" =================================================================
" キーバインド (Keymap)
" =================================================================
" インサートモードから抜ける
inoremap <silent> jj <ESC>

" Emacs like keybindings in Insert Mode
" ※ 補完メニュー(PUM)が出ている時は、メニュー選択を優先するように調整
inoremap <expr> <C-n> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <C-p> pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
" <C-d>, <C-k> 等は通常動作

" コマンド入力中断 (Emacs style cancel)
inoremap <silent> <C-g> <ESC><ESC><ESC><CR>a

" 画面分割と移動 (Emacs style window management)
" ※ 元の設定に合わせていますが、Insertモードに戻る挙動は好みが分かれます
inoremap <silent> <C-x>1 <ESC>:only<CR>a
inoremap <silent> <C-x>2 <ESC>:sp<CR>a
inoremap <silent> <C-x>3 <ESC>:vsp<CR>a
inoremap <silent> <C-x>o <ESC><C-w>w<CR>a
inoremap <silent> <C-x>p <ESC><C-w>p<CR>a

" 編集・削除系
inoremap <C-k> <C-o>d$
inoremap <C-y> <C-o>p
inoremap <C-d> <C-o>x

" 折り返し行移動
nnoremap j gj
nnoremap k gk

" x, s でヤンク（コピー）しない（ブラックホールレジスタへ）
nnoremap x "_x
nnoremap s "_s

" =================================================================
" プラグイン (Plugins)
" =================================================================
call plug#begin('~/.vim/plugged')
" 基本・UI
Plug 'vim-jp/vimdoc-ja'                " 日本語ヘルプ
Plug 'reireias/vim-cheatsheet'         " チートシート
Plug 'simeji/winresizer'               " ウィンドウサイズ変更 (Ctrl+e)
Plug 'vim-airline/vim-airline'         " ステータスライン装飾
Plug 'nanotech/jellybeans.vim'         " ダークカラースキーム
Plug 'cormacrelf/vim-colors-github'    " ライトカラースキーム
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " FZF本体
Plug 'junegunn/fzf.vim'                " FZFのVim連携
Plug 'markonm/traces.vim'              " 置換のプレビュー

" 編集・Git・実行
Plug 'kana/vim-operator-user'
Plug 'kana/vim-operator-replace'       " 'R'で置き換え
Plug 'tpope/vim-fugitive'              " Git連携
Plug 'thinca/vim-quickrun'             " コード実行
Plug 'dhruvasagar/vim-table-mode'      " テーブル編集
Plug 'previm/previm'                   " Markdownプレビュー

" LSP / 補完 / Lint
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" -----------------------------------------------------------------
" プラグイン設定
" -----------------------------------------------------------------
" Help
set helplang=ja,en

" Cheatsheet
let g:cheatsheet#cheat_file = '~/.vim/cheatsheet.md'

" WinResizer
let g:winresizer_vert_resize = 1
let g:winresizer_horiz_resize = 1

" Airline
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#wordcount#enabled = 0
let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'y', 'z']]
let g:airline_section_c = '%t'
let g:airline_section_x = '%{&filetype}'
let g:airline_section_z = '%3l:%2v %{coc#status()}'
let g:airline#extensions#whitespace#enabled = 1
" Tab切り替え
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab

" Previm
let g:previm_open_cmd = 'open -a Google\ Chrome'

" Operator Replace
nmap R <Plug>(operator-replace)

" -----------------------------------------------------------------
" Coc.nvim 設定 (LSP & Completion)
" -----------------------------------------------------------------
" TABキーで補完を選択できるようにする
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Enterキーで決定
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 定義ジャンプなどの基本操作
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" K でドキュメント表示
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" -----------------------------------------------------------------
" カラースキーム (Color Scheme)
" -----------------------------------------------------------------
colorscheme github
" 背景透過設定
highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight LineNr ctermbg=none
highlight Folded ctermbg=none
highlight EndOfBuffer ctermbg=none
highlight Visual ctermbg=24
