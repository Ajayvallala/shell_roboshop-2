#!/bin/bash

app_name="payment"

source ./common.sh

checkroot
app_setup

dnf install python3 gcc python3-devel -y

pip3 install -r requirements.txt

appservice_setup

Print_time

