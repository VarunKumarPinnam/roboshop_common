#!/bin/bash

source ./common.sh
app_name=mysqld

dnf install mysql-server -y &>>$LOGS_FILE
validation $? "mysql installed"

systemctl enable mysqld &>>$LOGS_FILE
validation $? "mysql service enabled"

systemctl start mysqld  
validation $? "mysql service started"

mysql_secure_installation --set-root-pass RoboShop@1
validation $? "$Y root password has been updated.$N"

app_restart
total_execution_time
