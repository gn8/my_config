
export LANG=ja_JP.UTF-8
#export EDITOR=emacs
export EDITOR=vi
export MAIL=/var/spool/mail/$USERNAME

# Default Permit
# file:644 directory:755
umask 022

cdpath=(.. ~ ~/src ~/zsh)

# ??
setopt notify
setopt globdots
setopt pushdtohome
setopt cdable_vars
setopt autolist
setopt correctall
setopt recexact
setopt longlistjobs
setopt autoresume
setopt noclobber
setopt pushdminus
setopt cdable_vars

# History
HISTFILE=~/.zsh_history
HISTSIZE=100000          # メモリに保存される履歴の件数。(保存数だけ履歴を検索できる)
SAVEHIST=100000          # HISTFILE で指定したファイルに保存される履歴の件数
DIRSTACKSIZE=20

setopt correct            # コマンド自動修正機能
setopt auto_cd            # cdコマンド省略可
setopt auto_pushd         # "cd -[TAB]"でディレクトリ一覧が表示
setopt pushd_ignore_dups  # 同ディレクトリを履歴に追加しない
setopt hist_no_store      # historyコマンドをヒストリに記録しない
setopt hist_ignore_dups   # 直前と同じコマンドはヒストリに記録しない
#setopt extended_history   # ヒストリに詳細を記録する
setopt hist_reduce_blanks # 余計なスペースを削除してヒストリに記録する
setopt hist_ignore_space  # 行頭がスペースではじまるコマンドはヒストリに記録しない
setopt inc_append_history # 実行中のシェルを横断してヒストリに記録する
setopt share_history      # ヒストリのリアルタイム相互参照
setopt list_packed        # 補完候補を詰めて表示
setopt list_types         # 補完一覧ファイル種別表示
setopt nolistbeep         # 補完候補表示時などにビープ音をならないように設定
setopt multios            # shellの拡張機能のON
#setopt no_multios         # shellの拡張機能のOFF
setopt transient_rprompt  # 右側まで入力がきたら表示を消す
# グロブ
setopt extended_glob      # 拡張グロブを有効にする
setopt numeric_glob_sort  # 数値ソートを有効にする(echo)
setopt rm_star_silent     # グロブでの削除時の確認メッセージを非表示にする
#setopt nomatch            # グロブマッチしないときにエラーとしない
#setopt null_glob          # グロブマッチしないときにメッセージを非表示にする


# aliAas
alias emacs='nocorrect emacs'
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias j=jobs
alias h=history
alias grep=egrep
alias ll='ls -l'
alias la='ls -la'
alias E='emacsclient -t'
alias kill-emacs="emacsclient -e '(kill-emacs)'"
alias su='su -l'
alias du='du -h'
alias df='df -h'
alias where='command -v'
alias j='jobs -l'
# ディレクトリとディレクトリのシンボリックリンクのみ表示する
alias lsd='ls -ld *(-/DN)'

# "."で始まるファイルのみ表示する
alias lsa='ls -ld .*'

# global alias
alias -g M='|more'
alias -g H='|head'
alias -g T='|tail'
alias -g G='|grep'
alias -g GI='|grep -i'

alias -s php=emacs

# root時のエイリアス設定
case ${UID} in
0)
    alias checkports='pkg_version -v -l \<'
    alias updateports='cd /usr/ports && make update fetchindex && checkports'
    alias updateindex='cd /usr/ports && make index && portsdb -u'
    alias portsclean portsclean -CD
    ;;
esac

# csh風のsetenv関数で定義
setenv () { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }

# autoloadされる関数/コマンド補完設定ファイルを検索するパス
fpath=(${fpath} ~/.zsh/functions)

# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

# プロンプトの設定
#PROMPT="%{${fg[blue]}%}%m%{${fg[green]}%}%# "
RPROMPT=' %~'
case ${UID} in
0)
    PROMPT="%B%{[31m%}%/#%{[m%}%b "
    PROMPT2="%B%{[31m%}%_#%{[m%}%b "
    SPROMPT="%B%{[31m%}%r is correct? [n,y,a,e]:%{[m%}%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
    ;;
*)
    PROMPT="%{[31m%}%/%%%{[m%} "
    PROMPT2="%{[31m%}%_%%%{[m%} "
    SPROMPT="%{[31m%}%r is correct? [n,y,a,e]:%{[m%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
    ;;
esac

# set terminal title including current directory
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
	}
	;;
esac

## terminal configuration
#   ls色付け、補完候補に色付け、ターミナルタイトルにパスを表示
unset LSCOLORS
case "${TERM}" in
xterm)
	export TERM=xterm-color
	;;
kterm)
	export TERM=kterm-color
	# set BackSpace control charactBer
	stty erase
	;;
cons25)
	unset LANG
	export LSCOLORS=ExFxCxdxBxegedabagacad
	export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors \
	      'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
esac


# manマニュアルの配置されているディレクトリパス
manpath=(/usr/man /usr/lang/man /usr/local/man)
export manpath

zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile


# 補完
autoload -U compinit
compinit

# Emacsキーバインド
bindkey -e

autoload -U colors
colors

# 履歴検索機能のショートカット設定(複数行対応)
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# 
bindkey "^P" history-beginning-search-backward


# 先方予測機能を有効
autoload predict-on

# 独自の設定を別ファイルに
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine
