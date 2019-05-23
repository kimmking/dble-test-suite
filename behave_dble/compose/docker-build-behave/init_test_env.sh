#!/bin/bash
#run this script for the first time init environment

#ssh with no pwd
sshpass -psshpass scp -o "StrictHostKeyChecking no" ~/.ssh/id_rsa.pub dble-1:/root/.ssh/authorized_keys
sshpass -psshpass scp -o "StrictHostKeyChecking no" ~/.ssh/id_rsa.pub dble-2:/root/.ssh/authorized_keys
sshpass -psshpass scp -o "StrictHostKeyChecking no" ~/.ssh/id_rsa.pub dble-3:/root/.ssh/authorized_keys
sshpass -psshpass scp -o "StrictHostKeyChecking no" ~/.ssh/id_rsa.pub mysql:/root/.ssh/authorized_keys
sshpass -psshpass scp -o "StrictHostKeyChecking no" ~/.ssh/id_rsa.pub mysql-master1:/root/.ssh/authorized_keys
sshpass -psshpass scp -o "StrictHostKeyChecking no" ~/.ssh/id_rsa.pub mysql-master2:/root/.ssh/authorized_keys
sshpass -psshpass scp -o "StrictHostKeyChecking no" ~/.ssh/id_rsa.pub driver-test:/root/.ssh/authorized_keys

#init mysql passwd
mysql_install=("mysql" "mysql-master1" "mysql-master2" "dble-1" "dble-2" "dble-3")
count=${#mysql_install[@]}
for((i=0; i<count; i=i+1)); do
    ssh ${mysql_install[$i]}  "bash /usr/local/bin/mysql_init.sh"
done

bash /docker-build/resetReplication.sh