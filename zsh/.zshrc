# -----------------
# Homebrew
# -----------------
# zim の初期化や補完モジュールが Homebrew 配下のバイナリを探すより前に PATH を通す
eval "$(/opt/homebrew/bin/brew shellenv)"

# /usr/local/share/zsh/site-functions に古い Intel Homebrew 時代のダングリング
# シンボリックリンク (_brew) が残っており、zim の completion モジュールが
# compinit 前に行う fpath 内ファイルの mtime チェックで失敗し、compinit 自体が
# 実行されなくなる (compdef が定義されない) 問題があるため fpath から除外する。
fpath=(${fpath:#/usr/local/share/zsh/site-functions})

# Docker CLI 補完。Docker Desktop は .zshrc 末尾に compinit 付きで追記するが、
# zim が compinit を実行済みで二重呼び出しの警告が出るため、zim 初期化より前に
# fpath だけ追加し、compinit は zim に任せる。追記された場合は削除すること。
fpath=($HOME/.docker/completions(N-/) $fpath)

# Start configuration added by Zim Framework install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim Framework install

# =================================================================
# User Configuration (ここから下を追加設定として追記)
# =================================================================

# -----------------
# 環境変数設定
# -----------------
export LANG=ja_JP.UTF-8         # 日本語環境
export EDITOR='vim'             # デフォルトエディタ
export PAGER='less'
export BROWSER='open'
export PIPENV_VENV_IN_PROJECT=1
export TCLLIBPATH="/usr/local/lib"

# Claude Code: テレメトリー・エラーレポート等の非必須通信を無効化
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export DISABLE_TELEMETRY=1
export DISABLE_ERROR_REPORTING=1

# Less の挙動設定
export LESS='-g -i -M -r -S -w -z-4'
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# path 配列の重複を除去しつつ ~/.bin 等を追加
typeset -gU cdpath fpath mailpath path
path=(
  /usr/local/{bin,sbin}
  $HOME/.bin
  $HOME/.local/bin
  $path
)

# -----------------
# 履歴設定
# -----------------
HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000000     # メモリ内の履歴数
export SAVEHIST=1000000     # 保存する履歴ファイル数

setopt SHARE_HISTORY         # 複数のターミナル間で履歴を共有
setopt HIST_REDUCE_BLANKS    # 余分な空白を削除して履歴保存
setopt HIST_IGNORE_SPACE     # 先頭スペースで履歴除外 (パスワード入力時などに便利)
setopt EXTENDED_HISTORY      # 履歴に実行時刻も記録
setopt EXTENDED_GLOB         # 高機能なワイルドカード展開
setopt LIST_PACKED           # 補完候補を詰めて表示
setopt PRINT_EIGHT_BIT       # 日本語ファイル名を表示可能にする
setopt NO_FLOW_CONTROL       # フローコントロールを無効にする
setopt INTERACTIVE_COMMENTS  # '#' 以降をコメントとして扱う
setopt IGNORE_EOF            # Ctrl + D での誤終了防止
setopt NO_BEEP               # ビープ音無効

# ディレクトリスタック (cd履歴)
setopt AUTO_PUSHD            # cd 時に自動的に pushd する
setopt PUSHD_IGNORE_DUPS     # スタックに重複を入れない
setopt PUSHD_SILENT          # pushd/popd 時にディレクトリを表示しない

# コマンド入力中に M-p, M-n で履歴検索できるようにする
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[p" history-beginning-search-backward-end
bindkey "^[n" history-beginning-search-forward-end

# -----------------
# グローバルエイリアス
# -----------------
alias -g L='| less'
alias -g G='| grep'

if [[ $(uname) == 'Darwin' ]]; then
    alias -g C='| pbcopy'
fi

# -----------------
# 基本エイリアス
# -----------------
if [[ $(uname) == 'Darwin' ]]; then
    # macOS用 (BSD ls)
    alias ls='ls -G'
    alias ll='ls -lG'
    alias la='ls -laG'
else
    # Linux用 (GNU ls)
    alias ls='ls --color=auto'
    alias ll='ls -l --color=auto'
    alias la='ls -la --color=auto'
fi

# 安全対策 (上書き・削除前の確認)
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# ディレクトリ移動の短縮
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# 全履歴の一覧を出力する
alias -g hall="history -E -i 1"

# locate.updatedb alias
alias updatedb='sudo /usr/libexec/locate.updatedb'

# generate password alias
alias pw='pwgen -1s 12 | tr -d "\n" | pbcopy'

# .DS_Store 削除
alias delds='find . -name ".DS_Store" -type f -print -delete'

# -----------------
# anyframe
# -----------------
fpath=($HOME/.zsh/anyframe(N-/) $fpath)
autoload -Uz anyframe-init
anyframe-init

# ^S : ディレクトリの移動履歴を表示
bindkey '^S' anyframe-widget-cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# ^R : コマンドの実行履歴を表示
bindkey '^R' anyframe-widget-put-history

# ^O : ファイル名を挿入
bindkey '^O' anyframe-widget-insert-filename

# aw : select-widget を起動
alias aw=anyframe-widget-select-widget

# -----------------
# git-escape-magic
# -----------------
fpath=($HOME/.zsh/zsh-git-escape-magic(N-/) $fpath)
autoload -Uz git-escape-magic
git-escape-magic

# -----------------
# 外部ツール設定 (インストールされている場合のみ有効)
# -----------------
# starship
eval "$(starship init zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# direnv
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

# asdf
if [[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]]; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
elif [[ -f $HOME/.asdf/asdf.sh ]]; then
  . $HOME/.asdf/asdf.sh
fi

# kubectl
if (( $+commands[kubectl] )); then
  source <(kubectl completion zsh)
  alias k=kubectl
  compdef __start_kubectl k
fi

# iTerm2 Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
