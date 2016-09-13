# home directory of the user which logged in
if [[ ! -n "$ZDOTDIR" ]];then
	export ZDOTDIR=$HOME;
fi
# zgen use HOME instead of ZDOTDIR
export ZGEN_DIR=$ZDOTDIR/.zgen;

# agnoster l'utilise pour masquer le nom de l'utilisateur
export DEFAULT_USER=joseph

alias compinit="compinit -u"

# load zgen
source "${ZDOTDIR}/.zgen/zgen.zsh"
# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/urltools
    zgen oh-my-zsh plugins/colored-man-pages

		autoload -U is-at-least
		if is-at-least 4.3.17; then
			zgen load zsh-users/zsh-syntax-highlighting
		fi

    zgen load zsh-users/zsh-completions src

		# must be loaded before theme
		zgen load ${HOME}/.zshrc-local

    # themes
		# arrow is fast
    #zgen oh-my-zsh themes/arrow
    #zgen oh-my-zsh themes/kphoen
		zgen load jolan78/agnoster-zsh-theme agnoster


    zgen save
fi

# avit does not load correctly from function :(
# frisk is opk on clear bg
# gentoo is classic
# kphoen is ok on both clear or dark bg
function alt-prompt() {
	if [[ ! -z $1 ]]; then
		theme=$1;
	else
		theme="kphoen";
	fi
	echo loading theme $theme;
	zgen oh-my-zsh themes/$theme;
}

if [[ -f $HOME/.iterm2_shell_integration.zsh ]];then
	source $HOME/.iterm2_shell_integration.zsh
fi

# conserve la config de l'utilisateur d'origine
export VIMINIT="let \$SSHUSER_HOME=\"$ZDOTDIR\" | so $ZDOTDIR/.vimrc | let \$MYVIMRC = \"$ZDOTDIR/.vimrc\""
# remplace su par une version qui conserve le shell de l'utilisateur d'origine
if [ "`uname`" = "Darwin" ]; then
	alias su="sudo -s";
else
	alias su="su -s $SHELL";
fi
# redéfinit HOME et autres variables, quand on a utilisé l'alias su
HOME=~$(whoami)
HISTFILE=$HOME/.zsh_history

# See http://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxbxbxbxbxbxbx"
export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=31;40:cd=31;40:su=31;40:sg=31;40:tw=31;40:ow=31;40:"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

alias glog="git log --color --decorate --graph --stat --abbrev-commit"
compdef _git glog="git log"

autoload zmv
