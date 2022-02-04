#!/bin/bash
# 两个文件/文件夹交换文件名

file1=$1
file2=$2

# determine absolute path
if [[ ${file1:0:1} != "/" ]]; then
    file1=$PWD/$file1
fi
if [[ ${file2:0:1} != "/" ]]; then
    file2=$PWD/$file2
fi

# ensure the suffix
file1=${file1%'/'}
file2=${file2%'/'}

# determine filename
name1=$(echo $file1 | awk -F'/' '{print $NF}')
name2=$(echo $file2 | awk -F'/' '{print $NF}')

# determine parent path, temp path
temp_path=${file1%$name1}

# exchange
mv $file1 ${temp_path}temp
mv $file2 $file1
mv ${temp_path}temp $file2

echo -e "\e[34m"`date +%Y-%m-%d` `date +%H:%M:%S`"\e[0m" "Successfully changing."