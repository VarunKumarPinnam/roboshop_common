USERID=$(id -u)
LOGS_DIRECTORY="/var/log/shell-script"
SHELL_DIR=$PWD
SCRIPT_NAME=$(basename "$0")
LOGS_FILE="$LOGS_DIRECTORY/${SCRIPT_NAME}_$(date '+%Y-%m-%d_%H-%M-%S').log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
START_TIME=$(date +%s)
MONGODB_HOST=mongodb.advidevops.online
MYSQL=mysql.advidevops.online

#--Log Directory---
    mkdir -p $LOGS_DIRECTORY
echo -e " $YScript started executing at : $(date '+%Y-%m-%d %H:%M:%S')" $N | tee -a $LOGS_FILE

#--ROOT User Check--
check_root(){
  if [ "$USERID" -ne 0 ]; then 
     echo -e "$R You must run this script with root access $N" 
     exit 1
  fi
}

validation(){
  if [ $1 -ne 0 ]; then 
    echo -e "$R $2..FAILED $N" | tee -a $LOGS_FILE
    exit 1
  else
    echo -e "$G $2..SUCCESS $N" | tee -a $LOGS_FILE
 fi
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOGS_FILE
    validation $? "nodejs module disabling is"

    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    validation $? "nodejs module enabling is"

    dnf install nodejs -y &>>$LOGS_FILE
    validation $? "nodejs installation is"

    npm install &>>$LOGS_FILE
    validation $? "installing dependencies" 

}

java_setup(){
    dnf install maven -y &>>$LOGS_FILE
    validation $? "maven installed"

    cd /app
    mvn clean package &>>$LOGS_FILE
    validation $? "installing dependencies" 

    mv target/$app_name-1.0.jar $app_name.jar 
    validation $? "Moving and Renaming $app_name"
}

python_steup(){
    dnf install python3 gcc python3-devel -y &>>$LOGS_FILE
    validation $? "python installation"
    
    cd /app
    pip3 install -r requirements.txt &>>$LOGS_FILE
    validation $? "installing dependencies" 
}

app_setup(){
 #..creating system user
    id roboshop &>>$LOGS_FILE

    if [ $? -ne 0 ]; then 
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
        echo -e "$Y User roboshop has been created $N"
    else 
        echo -e  "$Y User already exists, skipping this step $N"
    fi

 #..creating app directory
    mkdir -p /app
    validation $? "creating an app directory"

 #..downloading the files
    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOGS_FILE
    validation $? "Download $app_name code"

    cd /app 
    validation $? "Moving to app directory"

    rm -rf /app/*
    validation $? "removing the existing code"

    #..unzippng the files
    unzip /tmp/$app_name.zip &>>$LOGS_FILE
    validation $? "unzipping the files"

}

systemd_setup(){

    cp $SHELL_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOGS_FILE
    validation $? "$app_name service updated"

    systemctl daemon-reload 
    validation $? "system daemon reloaded"

    systemctl enable $app_name &>>$LOGS_FILE
    validation $? "$app_name service enable is"

    systemctl start $app_name
    validation $? "$app_name service start is"
}
app_restart(){
    systemctl restart $app_name
    validation $? "system restart"
}
total_execution_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e " Execution time :$G $TOTAL_TIME seconds $N " | tee -a $LOGS_FILE
}