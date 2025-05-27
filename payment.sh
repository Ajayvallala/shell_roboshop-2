#!/bin/bash

app_name="payment"

source ./common.sh

checkroot

app_setup

dnf install python3 gcc python3-devel -y &>>$LOG_FILE
VALIDATE $? "Installing python"

pip3 install -r requirements.txt &>>$LOG_FILE
VALIDATE $? "Installing Dependencies"

appservice_setup

systemctl restart payment &>>$LOG_FILE
VALIDATE $? "Restarting Payment service"

Print_time

