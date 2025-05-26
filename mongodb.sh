#!/bin/bash

app_name=mongodb

source ./common.sh

checkroot

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-org -y
VALIDATE $? "Installing mongodb"

systemctl enable mongod 
VALIDATE $? "Enabling mongodb"

systemctl start mongod
VALIDATE $? "Starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Updating mongodb conf file"

systemctl restart mongod
VALIDATE $? "Restarting mongodb"

Print_time

