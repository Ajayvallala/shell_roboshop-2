#!/bin/bash

app_name="catalogue"

source ./common.sh

checkroot

app_setup

nodejs_setup

appservice_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongodb.repo
VALIDATE $? "Copying Mongodb repo"

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Installing Mongodb client to load the data"

mongosh --host mongodb.vallalas.store --eval 'db.getMongo().getDBNames().indexOf("catalogue")' &>>$LOG_FILE

if [ $? -lt 0 ]
then
 mongosh --host mongodb.vallalas.store < /app/db/master-data.js &>>$LOG_FILE
 VALIDATE $? "Data loading to database"
else
 echo -e "Data has been already loaded into database so $Y skipping....$N" | tee -a $LOG_FILE
fi

Print_time
