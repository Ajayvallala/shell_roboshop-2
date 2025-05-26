#!/bin/bash

START_TIME=$(date +%s)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[37m"

USER_ID=$(id -u)
LOG_FOLDER="/var/log/shell_scrip/"
LOG_FILE_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER$LOG_FILE_NAME.log"
SCRIPT_DIR=$PWD

checkroot(){
    if [ $USER_ID -ne 0 ]
    then 
    echo -e "$R Please switch to root user to run the script $N" 
    exit 1
    else
    mkdir -p $LOG_FOLDER
    echo "Script excectation stated at $(date)" | tee -a $LOG_FILE
    echo -e "$G You are running the script with root access$N" | tee -a $LOG_FILE
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
     echo -e "$2 is : $R Failure $N" | tee -a $LOG_FILE
     exit 1
    else 
     echo -e "$2 is : $G Success $N" | tee -a $LOG_FILE
    fi
}

app_setup()
{
    id roboshop
    if [ $? -ne 0 ]
    then
     mkdir -p /app
     useradd --system --home /app --shell /sbin/nologin --comment "roboshop user" roboshop &>>$LOG_FILE
     VALIDATE $? "System user creation"
    else
     echo -e "User already created so $Y skipping $N" | tree -a $LOG_FILE
    fi

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE

    rm -rf /app/*

    cd /app

    unzip /tmp/$app_name.zip &>>$LOG_FILE
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE

    dnf module enable nodejs:20 -y &>>$LOG_FILE

    dnf install nodejs -y &>>$LOG_FILE

    npm install &>>$LOG_FILE
}

appservice_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Creating system service file"

    systemctl daemon-reload &>>$LOG_FILE
    VALIDATE $? "Daemon reload"
    
    systemctl enable $app_name &>>$LOG_FILE
    VALIDATE $? "Enable $app_name"

    systemctl start $app_name &>>$LOG_FILE
    VALIDATE $? "Starting $app_name"
}



Print_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME - $START_TIME)) &>>$LOG_FILE
    echo -e "Script execution completed successfully, total time took :$G $TOTAL_TIME second$N" | tee -a $LOG_FILE
}



