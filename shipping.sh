#!/bin/bash

source ./common.sh
app_name=shipping

check_root
app_setup
java_setup
systemd_setup

#......Installing mysql client......#

dnf install mysql -y &>>$LOGS_FILE
validation $? "mysql client is installed"

mysql -h $MYSQL -uroot -pRoboShop@1 -e 'use cities'

if [ $? -ne 0 ];then
    mysql -h $MYSQL -uroot -pRoboShop@1 < /app/db/schema.sql
    mysql -h $MYSQL -uroot -pRoboShop@1 < /app/db/app-user.sql
    mysql -h $MYSQL -uroot -pRoboShop@1 < /app/db/master-data.sql
    validation $? "Data loaded to Mysql"
else
    echo -e "$Y data is already loaded ..skipping this step $N"
fi

app_restart