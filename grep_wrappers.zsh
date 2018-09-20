#!/bin/zsh
#
# Grep wrappers
# can be sourced or linked for use by non-zsh shells
# when linked, the link name must be the name of the function needed
#
# the functions works like grep.and automatically detect '.gz' in the filename
#
# gl : [z]grep ... |less
# tg : tail -f ... | grep ...
#
# these wrappers are specialized versions for specific log files
# filename defaults to the current log file
# if the filename is numerical, it defaults to the nth log file
# if the filename is an existing file, it works like gl or tg
#
# ex(gl|tg)  : like gl/tg but the file defaults to /var/log/exim/mainlog

unalias tg gl exgl extg 2>/dev/null

function {tg,gl,exgl,extg} () {

	local default_file=''
	case $0[1,-3] in
		gl,tg);;
		ex) default_file='/var/log/exim4/mainlog';;
		*) return 1;;
	esac

	local pattern=''
	local -a files
	local -a gropt
	local after_dashdash=false
	for ar in $argv ; do
		if [[ ($after_dashdash == false) && ($ar[1] == '-') ]] ; then
			if [[ $pattern != '' ]] ; then
				printf 'error : otions after arguments' 2>&1
				return 1;
			fi
			if [[ $ar == '--' ]];then
				after_dashdash=true
			fi
			gropt+=($ar)
		elif [[ $pattern != '' ]];then
			if [[ ($default_file != '') && ($ar[-1] =~ '^[0-9]*$') ]];then
				local file="$default_file.$ar"
				if [[ -r "$file.gz" ]];then
					file="$file.gz"
				fi
				ar=$file
			fi

			files+=($ar)
		else
			pattern=$ar
		fi
	done

	if [[ ($#files == 0) && ($default_file != '') && ($pattern != '')]];then
		files+=($default_file)
	fi

	if [[ $0[-2,$] == 'gl' ]]; then
		local grcmd='grep'
		local f
		for f in $files; do
			if [[ $f =~ '\.gz$' ]]; then
				grcmd='zgrep'
			fi
		done
		$grcmd $gropt $pattern $files| less
	elif [[ $0[-2,$] == 'tg' ]]; then
		tail -f $files | grep $gropt $pattern
	fi
}

if [[ $(readlink $0) == "" ]];then
	# being sourced, install completion
	compdef tg=grep
	compdef extg=grep
	compdef gl=grep
	compdef exgl=grep
	FAST_HIGHLIGHT+=(chroma-tg chroma/-grep.ch\
		chroma-gl chroma/-grep.ch
		chroma-exgl chroma/-grep.ch
		chroma-extg chroma/-grep.ch)
else
	# called with a symlink, running the corresponding function
	$0:t $*
fi
