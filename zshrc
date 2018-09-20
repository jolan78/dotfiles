# Uncomment line below to troubleshoot startup speed issues
# BENCHMARK=1 && zmodload zsh/zprof


# home directory of the user which logged in
if [[ ! -n "$ZDOTDIR" ]];then
  export ZDOTDIR=$HOME;
fi

# agnoster l'utilise pour masquer le nom de l'utilisateur
export DEFAULT_USER=joseph

# must be loaded before theme
source "${ZDOTDIR}/.zshrc-local"

###################### key bindings ################
## keys must be binded before syntax plugins
bindkey -e
# set application mode for terminfo to work
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
	function zle-line-init () { echoti smkx }
	function zle-line-finish () { echoti rmkx }
	zle -N zle-line-init
	zle -N zle-line-finish
fi
# up/down search entry starting with current entry (even with spaces)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search # Up
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search # Down
bindkey '^[b' emacs-backward-word # alt-left
bindkey '^[f' emacs-forward-word # alt-right
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^[[3~" delete-char # del
bindkey "^[[Z" reverse-menu-complete # Shift-Tab
autoload edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line # ^X^E : edit current line in editor
# [Ctrl-r] - Search backward incrementally for a specified string.
# The string may begin with ^ to anchor the search to the beginning of the line.
bindkey '^r' history-incremental-search-backward

####################### Zplugin ######################
export ZPLUGIN_HOME=$ZDOTDIR/.zplugin

if [[ ! -a  "${ZPLUGIN_HOME}/bin/zplugin.zsh" ]]; then
  printf "Install Zplugin? [y/N]: "
  if read -q; then
		mkdir -p "${ZPLUGIN_HOME}/bin"
    echo; git clone https://github.com/zdharma/zplugin.git ${ZPLUGIN_HOME}/bin && zcompile ${ZPLUGIN_HOME}/bin/zplugin.zsh
  fi
fi

if [[ -a  "${ZPLUGIN_HOME}/bin/zplugin.zsh" ]]; then
	# module built with 'zplugin module build', automatically compiles sourced scripts
	if [[ -f "${ZPLUGIN_HOME}/bin/zmodules/Src/zdharma/zplugin.so" ]]; then
			module_path+=( "${ZPLUGIN_HOME}/bin/zmodules/Src" )
			zmodload zdharma/zplugin
	else
		echo 'zplugin module is not available. (zplugin module build)'
	fi

  source "${ZPLUGIN_HOME}/bin/zplugin.zsh"

	# provides urlencode / urldecode
  zplugin snippet OMZ::plugins/urltools/urltools.plugin.zsh

  zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

	# fish-like autosuggestions
	zplugin light zsh-users/zsh-autosuggestions

	zplugin ice atload'ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)'
	zplugin light zdharma/fast-syntax-highlighting

	zplugin ice blockf atload'ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=239"'
  zplugin light zsh-users/zsh-completions
	zplugin ice atload"bindkey '^[[1;9A' history-substring-search-up; bindkey '^[[1;9B' history-substring-search-down" # alt up/down for substring search
  zplugin light zsh-users/zsh-history-substring-search

	zplugin ice pick"grep_wrappers.zsh"
	zplugin light jolan78/dotfiles
	
  # themes
	setopt promptsubst # most theme need this
  zplugin load jolan78/agnoster-zsh-theme

	# plug-ins to try :
	# records visited paths and use fzf/peco to choose one :
	# zplug "b4b4r07/enhancd", of:enhancd.sh
	# a fast? git pronpt for use in themes :
	# zplug "olivierverdier/zsh-git-prompt", of:"*.sh"
	# auto completion on-the-fly :
	# zplug "hchbaw/auto-fu.zsh", at:pu
  # Vanilla shell :
  # zplug "yous/vanilli.sh"
	# better powerline theme :
	# zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

	autoload -Uz compinit
	compinit

	zplugin cdreplay -q # -q is for quiet
fi

###################### theme-related functions ################
compdef "_arguments '1:Theme:((\
	kphoen:\"(default) works well on both clear and dark background\"\
 	gentoo\:\"classic theme\"\
 	arrow\:fast\
 	frisk\:\"works well on clear background\"\
 	avit\:buggy\
	))'" alt-prompt

function alt-prompt() {
  if [[ ! -z $1 ]]; then
    theme=$1;
  else
    theme="kphoen";
  fi
  echo loading theme $theme;
	# remove agnoster hook
	add-zsh-hook -d precmd prompt_agnoster_precmd
	# load colors
	autoload colors
	colors
	# load required plugins
	zplugin snippet OMZ::lib/git.zsh
	zplugin snippet OMZ::plugins/git/git.plugin.zsh
	#load theme
	zplugin snippet OMZ::themes/${theme}.zsh-theme
}

# change agnoster characters to non-powerine approximation
function nopowerline() {
	SEGMENT_SEPARATOR="\u25BA"
  BRANCH="\u16B4"
}
function powerline() {
	SEGMENT_SEPARATOR="\ue0b0"
  BRANCH="\ue0a0"
}

if [[ -f ${ZDOTDIR}/.iterm2_shell_integration.zsh ]];then
  source ${ZDOTDIR}/.iterm2_shell_integration.zsh
fi

export PATH="${PATH}:${ZDOTDIR}/bin"

# conserve la config vim de l'utilisateur d'origine
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
HISTSIZE=13000
SAVEHIST=10000

# See http://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxbxbxbxbxbxbx"
export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=31;40:cd=31;40:su=31;40:sg=31;40:tw=31;40:ow=31;40:"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select # completion menu is browsable
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*' #case insensitive
zstyle ':completion:*' group-name '' # group completions
zstyle ':completion:*:descriptions' format '%B=== %d ===%b' # format for group names

setopt auto_menu              # show completion menu on successive tab press

## cd
setopt auto_cd                # try cd if a command does not exist
setopt auto_pushd             # push old directory on cd
setopt pushd_ignore_dups
## completion
setopt always_to_end          # move cursor to the end on completion
setopt complete_in_word       # allow completion in the middle of a word
unsetopt list_beep            # no beep on ambigous completion
## History command configuration
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data
# these two options are set by share_history:
#setopt extended_history       # record timestamp of command in HISTFILE
#setopt inc_append_history     # add commands to HISTFILE in order of execution


alias glog="git log --color --decorate --graph --stat --abbrev-commit"
compdef _git glog="git log"
alias l='ls -lah'
alias ls='ls -G'
alias grep='grep --color=auto --exclude-dir="{.bzr,CVS,.git,.hg,.svn}"'

autoload zmv

if [[ -n "$BENCHMARK" ]] ;
    then zprof > "$HOME/.zsh_bench"
fi

