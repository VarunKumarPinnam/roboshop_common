#!/bin/bash


source ./common.sh

app_name=frontend
app_dir=/usr/share/nginx/html
check_root


dnf module disable nginx -y &>>$LOGS_FILE
validation $? "nginx module disabled"

dnf module enable nginx:1.24 -y &>>$LOGS_FILE
validation $? "nginx module enabled"

dnf install nginx -y &>>$LOGS_FILE
validation $? "nginx installated"

systemctl enable nginx &>>$LOGS_FILE
validation $? "$G enabled nginx service $N"

systemctl start nginx
validation $? "$G started nginx service $N"


rm -rf /usr/share/nginx/html/* 
validation $? "$Y removed default html content $N"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOGS_FILE
validation $? "$Y fronted code downloaded $N"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOGS_FILE
validation $? "$Y frontend code unzipped to html folder $N"

sed -i d /etc/nginx/nginx.conf 
validation $? "$Y removed default nginx config data $N"

cp $SHELL_DIR/nginx.conf /etc/nginx/nginx.conf
validation $? "$Y updated new configuration to nginx.conf file $N"

systemctl restart nginx 
validation $? "$Y Nginx service restarted $N"