#!/bin/bash

app_name="shipping"

source ./common.sh

checkroot

echo "Please enter mysql root password"
read -s Mysql_root_password

app_setup

dnf install maven -y &>>$LOG_FILE
VALIDATE $? "Installing maven"

mvn clean package &>>$LOG_FILE
VALIDATE $? "Packaging source code"

mv target/shipping-1.0.jar shipping.jar

appservice_setup

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "Installing mysql client"

mysql -h mysql.vallalas.store -uroot -p$Mysql_root_password -e 'use cities' &>>$LOG_FILE

if [ $? -ne 0 ]
then 
 mysql -h mysql.vallalas.store -u root -p$Mysql_root_password < /app/db/schema.sql &>>$LOG_FILE
 mysql -h mysql.vallalas.store -u root -p$Mysql_root_password < /app/db/app-user.sql &>>$LOG_FILE
 mysql -h mysql.vallalas.store -u root -p$Mysql_root_passowrd < /app/db/master-data.sql &>>$LOG_FILE

else
 echo -e "Data has been already loaded in to database so $Y skipping....$N"
fi

systemctl restart shipping &>>$LOG_FILE
VALIDATE $? "Restarting shipping service"

Print_time



