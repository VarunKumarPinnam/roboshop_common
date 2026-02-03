#!/bin/bash

source ./common.sh

check_root

cp $SHELL_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
validation $? "$G copying rabbitMQ repo $N"

dnf install rabbitmq-server -y &>>$LOGS_FILE
validation $? "rabbitmrabbitMQ installation"

systemctl enable rabbitmq-server &>>$LOGS_FILE
validation $? "rabbitmrabbitMQ service enable"

systemctl start rabbitmq-server 
validation $? "rabbitmrabbitMQ service start"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGS_FILE
validation $? "roboshop user creation"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGS_FILE
validation $? "persmissions update"

total_execution_time
