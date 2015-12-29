#!/bin/sh
dotfiles==${(dirname $0):a}

if [[ ! -f ${HOME}/.zgen/zgen.zsh ]];then
	echo 'installing zgen';
	git clone https://github.com/tarjoilija/zgen.git ${HOME}/.zgen
fi

for file in zshrc vimrc ;do
	path=$HOME/.$file
	if [[ ! -h $path ]];then
		if [[ -f $path ]];then
			echo "saving previous .$file to $path.backup"
			mv $path $path.backup
		fi
		echo "creating a link to $file"
		ln -s $dotfiles/$file $path
	fi
done
