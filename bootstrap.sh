#!/bin/zsh
dotfiles=${$(dirname $0):a}

for file in iterm2_shell_integration.zsh zshrc vimrc ;do
	path=$HOME/.$file
	if [[ ! -h $path ]];then
		if [[ -f $path ]];then
			echo "saving previous .$file to $path.backup"
			/bin/mv $path $path.backup
		fi
		echo "creating a link to $file"
		/bin/ln -s $dotfiles/$file $path
	fi
done
