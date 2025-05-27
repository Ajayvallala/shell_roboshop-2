#!/bin/bash

app_name="mysql"

source ./common.sh

checkroot

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing mysql"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabling mysql"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Starting mysql"

echo "Please enter mysql root password"
read -s Mysql_root_pass &>>$LOG_FILE

mysql_secure_installation --set-root-pass $Mysql_root_pass &>>$LOG_FILE

Print_time

