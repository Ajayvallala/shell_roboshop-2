#!/bin/bash

source ./common.sh

checkroot

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disabling default redis version"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "Enabling redis 7 version"

dnf install redis -y &>>$LOG_FILE
VALIDATE $? "Installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOG_FILE
VALIDATE $? "Updating redis conf file"

systemctl enable redis &>>$LOG_FILE
VALIDATE $? "Enabling redis"

systemctl start redis &>>$LOG_FILE
VALIDATE $? "Starting redis"

Print_time

