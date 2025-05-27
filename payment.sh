#!/bin/bash

app_name="payment"

source ./common.sh

checkroot

app_setup

dnf install python3 gcc python3-devel -y &>>$LOG_FILE

pip3 install -r requirements.txt &>>$LOG_FILE

appservice_setup

Print_time

