#!/bin/bash

source ./common.sh

checkroot

echo "Please enter rabbitmq user password"
read -s Rabbirmq_user_password

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Creating rabbitmq repo file"

dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "Installing rabbitmq"

systemctl enable rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Enabling rabbitmq"

systemctl start rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Starting rabbitmq"

rabbitmqctl add_user roboshop $Rabbirmq_user_password &>>$LOG_FILE
VALIDATE $? "Creating rabbitmq user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
VALIDATE $? "Setting permissions rabbitmq"

Print_time





