#!/bin/bash

source ./common.sh

check_root

cp $SHELL_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
validation $? "copying mongo repo"

dnf install mongodb-org -y &>>$LOGS_FILE
validation $? "mongo db server installation"

systemctl enable mongod &>>$LOGS_FILE
validation $? "enable mongo db"

systemctl start mongod &>> $LOGS_FILE
validation $? "start mongo db"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validation $? "allowing remote connections"

systemctl restart mongod &>> $LOGS_FILE 
validation $? "restart mongodb"

total_execution_time