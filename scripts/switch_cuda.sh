#!/bin/bash
# change cuda version

# check the user
if [ $(id -u) == "0" ]; then
    echo "Error: root cannot run this script, please change the user!"
    exit 1
fi

cudas=$(ls /usr/local/ | grep cuda-)
user=$(id | awk '{print $1}' | awk -F '(' '{print $2}' | awk -F ')' '{print $1}')
cuda_path=$(cat /home/${user}/.bashrc | grep "/usr/local/cuda/bin")

i=0
for cuda in ${cudas}
do
    i=`expr $i + 1`
done

if [ "${cuda_path}" = "" -o $i -eq 0 ]; then
    echo "w: 当前系统未安装cuda，或${user}未正确设置cuda的环境变量，请检查后重试"
    exit 1
fi

echo "有以下${i}个CUDA版本可以选择:"
i=0
for cuda in ${cudas}
do
    i=`expr $i + 1` 
    echo -e "${i}.${cuda}"
done

i=0
all_cuda=()
for cuda in ${cudas}
do
    all_cuda[${i}]=${cuda}
    i=`expr ${i} + 1` 
done

read -p "${user}你好，请输入你想切换的版本序号：" version
version=`expr $version - 1`
current_version=$(ls -l /usr/local/cuda | awk -F'->' '{print $2}' | awk -F'/' '{print $4}')
sudo -u root rm -rf /usr/local/cuda
sudo -u root ln -s /usr/local/${all_cuda[$version]} /usr/local/cuda
echo "当前cuda版本为${current_version}，将切换为${all_cuda[$version]}"
echo "记得执行 source ~/.bashrc "