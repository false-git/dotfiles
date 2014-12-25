#!/bin/sh

echo commonの下と、引数で指定したディレクトリにあるファイルを、
echo ホームディレクトリにシンボリックリンクを張ります。
echo 元のファイルは削除されます。
echo 問題がある場合はここで Ctrl+C を押してください。
echo 実行する場合は enter を押してください。
echo
/bin/echo -n "> "
read a
echo

mklink() {
    for i in * .??*
    do
	if [ -d "$i" ]
	then
	    echo "  $2$i/"
	    cd "$i"
	    mkdir -p "$HOME$1/$i"
	    mklink "$1/$i" "  $2"
	    cd ..
	elif [ -f "$i" ]
	then
	    echo "  $2$i"
	    target_file="$HOME$1/$i"
	    if [ -e "$target_file" -o -L "$target_file" ]
	    then
		rm -f "$target_file"
	    fi
	    ln -s "`pwd`/$i" "$HOME$1/"
	fi
    done
}

echo common/
cd common
mklink "" ""
cd ..

mkdir -p $HOME/.emacs.d
rm -f $HOME/.emacs.d/snippets
ln -s `pwd`/yasnippet/snippets $HOME/.emacs.d/

if [ -d "$1" ]
then
echo $1/
cd $1
mklink "" ""
cd ..
fi
