# home directory of the user which logged in
if [[ ! -n "$ORIG_HOME" ]];then
	export ORIG_HOME=$HOME;
fi

# agnoster l'utilise pour masquer le nom de l'utilisateur
export DEFAULT_USER=joseph

# load zgen
source "${ORIG_HOME}/.zgen/zgen.zsh"

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

# conserve la config de l'utilisateur d'origine
export VIMINIT="let \$SSHUSER_HOME=\"$ORIG_HOME\" | so $ORIG_HOME/.vimrc | let \$MYVIMRC = \"$ORIG_HOME/.vimrc\""
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

