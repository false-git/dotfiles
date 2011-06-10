#!/bin/sh

echo commonの下と、引数で指定したディレクトリにある.ファイルを、
echo ホームディレクトリにシンボリックリンクを張ります。
echo 元のファイルは削除されます。
echo 問題がある場合はここで Ctrl+C を押してください。
echo 実行する場合は enter を押してください。
echo
/bin/echo -n "> "
read a
echo

echo common/
cd common
for i in .??*
do
echo "  $i"
if [ -e $HOME/$i -o -L $HOME/$i ]
then
    rm -f $HOME/$i
fi
ln -s `pwd`/$i $HOME/
done
cd ..

if [ -d "$1" ]
then
echo $1/
cd $1
for i in .??*
do
echo "  $i"
if [ -e $HOME/$i -o -L $HOME/$i ]
then
    rm -f $HOME/$i
fi
ln -s `pwd`/$i $HOME/
done
cd ..
fi