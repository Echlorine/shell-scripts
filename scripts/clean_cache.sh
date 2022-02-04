#!/bin/bash
# clean the cache

# clean the systemd logs
logs_size=$(sudo du -sm /var/log/journal/ | awk '{print $1}')
if [ $logs_size -le 1000 ]
then 
    echo "The systemd logs take up just ${logs_size}Mb of disk space, no need to clean."
else
    sudo journalctl --rotate
    sudo journalctl --vacuum-time=7d
fi

# clean all users' cache
users=$(cat /etc/passwd | awk -F ':' '{printf "%-8s %d\n",$1,$3}')
ifs_old=$IFS
IFS=$'\n'
for user in $users
do
    uid=$(echo "${user}" | awk -F ' ' '{print $2}')
    user_name=$(echo "${user}" | awk -F ' ' '{print $1}')
    if [ $uid -ge 1000 -a $uid -le 2000 -a -d "/home/${user_name}/.cache/" ]
    then
        cache_size=$(sudo du -sh /home/${user_name}/.cache/ | awk '{print $1}')
        sudo rm -r "/home/${user_name}/.cache/"
        printf "Freed (uid:%d, user_name:%s)'s ${cache_size} space.\n" $uid $user_name
    fi
done
IFS=$ifs_old
