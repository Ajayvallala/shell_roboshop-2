#!/bin/bash

app_name="mysql"

checkroot

dnf install mysql-server -y

systemctl enable mysqld

systemctl start mysqld

read -s Mysql_root_pass

mysql_secure_installation --set-root-pass $Mysql_root_pass

