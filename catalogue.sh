#!/bin/bash

source ./common.sh
app_name=catalogue

check_root
app_setup
nodejs_setup
systemd_setup

echo -e "$Y starting...$N"

#Loading data to mongodb

cp $SHELL_DIR/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-mongosh -y &>>$LOGS_FILE
validation $? "installing mongodb"

INDEX=$(mongosh --host $MONGODB_HOST  --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $? -ne 0 ]; then
    echo -e "$R MongoDB is NOT connected. Cannot load data. Exiting... $N"
    exit 1
fi

if [ $INDEX -le 0 ]; then 
   mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOGS_FILE
   validation $? "loading products"
else
    echo -e "$Y data already loaded skipping this step $N"
fi

app_restart