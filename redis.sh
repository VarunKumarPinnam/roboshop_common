#!/bin/bash

source ./common.sh

check_root

dnf module disable redis -y &>>$LOGS_FILE
validation $? "redis module disabled"

dnf module enable redis:7 -y &>>$LOGS_FILE
validation $? "redis module enabled"

dnf install redis -y  &>>$LOGS_FILE
validation $? "redis installated"

# sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
# validation $? "$Y updated binding ip to 0.0.0.0 $N"

# sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis/redis.conf
sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
validation $? "$Y updated bindidng ip and protected mode to no $N"

systemctl enable redis &>>$LOGS_FILE
validation $? "$G enabled redis service $N"

systemctl start redis
validation $? "$G started redis service $N"

total_execution_time
