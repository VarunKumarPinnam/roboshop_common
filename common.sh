USERID=$(id -u)
LOGS_DIRECTORY="/var/log/shell-script"
SCRIPT_NAME=$(basename "$0")
LOGS_FILE="$LOGS_DIRECTORY/${SCRIPT_NAME}_$(date '+%Y-%m-%d_%H-%M-%S').log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
START_TIME=$(date +%s)

echo "Script started executing at : $SCRIPT_STARTTIME | tee -a $LOGS_FILE

#--ROOT User Check--
check_root(){
  if [ "$USERID" -ne 0 ]; then 
     echo -e "$R You must run this script with root access $N" 
     exit 1
  fi
}

#--Log Setup---
mkdir -p $LOGS_DIRECTORY


validation(){
  if [ $1 -ne 0 ]; then 
    echo -e "$R $2..FAILED $N" | tee -a $LOGS_FILE
    exit 1
  else
    echo -e "$G $2..SUCCESS $N" | tee -a $LOGS_FILE
 fi
}

total_execution_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME))
    echo -e "Execution time :$G $TOTAL_TIME seconds $N " | tee -a $LOGS_FILE
}