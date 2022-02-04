#!/bin/bash
# show all users expect root

users=$(cat /etc/passwd | awk -F ':' '{printf "%-8s %d\n",$1,$3}')

# backup IFS
ifs_old=$IFS
IFS=$'\n'

for user in $users
do
    uid=$(echo "${user}" | awk -F ' ' '{print $2}')
    user_name=$(echo "${user}" | awk -F ' ' '{print $1}')
    if [ $uid -ge 1000 -a $uid -le 2000 ]
    then
        printf "user_name:%-15s uid:%d\n" $user_name $uid
    fi
done

# recovery IFS
IFS=$ifs_old