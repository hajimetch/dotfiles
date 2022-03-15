#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


########################################
# オプション

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# cd したら自動的にpushdする
setopt auto_pushd

# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# 補完候補を詰めて表示する
setopt list_packed

# $HISTFILEに時間も記録
setopt extended_history


########################################
# キーバインド

# emacs 風キーバインドにする
bindkey -e


########################################
# コマンド履歴検索

# 履歴を保存するファイル
HISTFILE=$HOME/.zsh_history

# メモリ内の履歴の数
HISTSIZE=1000000

# $HISTFILE に保存される履歴の数
SAVEHIST=1000000

# コマンド入力中に M-p, M-n で履歴検索できるようにする
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[p" history-beginning-search-backward-end
bindkey "^[n" history-beginning-search-forward-end

# 全履歴の一覧を出力する
alias -g hall="history -E -i 1"


########################################
# エイリアス

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# C で標準出力をクリップボードにコピーする
alias -g C='| pbcopy'

# git ショートカットを一覧化
alias -g zgit='cat ~/.zprezto/modules/git/alias.zsh | grep "alias " | less'

# ls/exa aliases
if [[ $(command -v exa) ]]; then
  alias -g l='exa --time-style=long-iso -g'
  alias -g ll='exa --git --time-style=long-iso -gl'
  alias -g la='exa --git --time-style=long-iso -agl'
  alias -g lt='exa -T -L 3 -a -I "node_modules|.git|.cache"'
  alias -g lta='exa -T -a -I "node_modules|.git|.cache" --color=always | less -r'
fi

# brew alias
alias brew='PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin brew'

# locate.updatedb alias
alias updatedb='sudo /usr/libexec/locate.updatedb'

# generate password alias
alias pw='pwgen -1s 12 | tr -d "\n" | pbcopy'

# delete .DS_Store files alias
alias delds='find . -name ".DS_Store" -type f -print -delete'

# less_with_unbuffer alias
less_with_unbuffer () {
    unbuffer "$@" |& less -SR
}
alias ul=less_with_unbuffer


########################################
# anyframe

# 初期設定
fpath=($HOME/.zsh/anyframe(N-/) $fpath)
autoload -Uz anyframe-init
anyframe-init

# ^S
# ディレクトリの移動履歴を表示
bindkey '^S' anyframe-widget-cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# ^R
# コマンドの実行履歴を表示
bindkey '^R' anyframe-widget-put-history

# ^O
# ファイル名を挿入
bindkey '^O' anyframe-widget-insert-filename

# aw
# select-widget を起動
alias aw=anyframe-widget-select-widget


########################################
# git-escape-magic

# 初期設定
fpath=($HOME/.zsh/zsh-git-escape-magic(N-/) $fpath)
autoload -Uz git-escape-magic
git-escape-magic


########################################
# iTerm2 Shell Integration 設定

if [ "$TERM" = "xterm-256color" ]; then
    test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
fi


########################################
# Other

# asdf
. /usr/local/opt/asdf/libexec/asdf.sh

# kubectl
source <(kubectl completion zsh)
alias k=kubectl
compdef __start_kubectl k

