#!/usr/bin/env bash

## Install python, pipenv and nginx

WORK_DIR="/var/www/html/price-service"
LOG_DIR='/var/log/price-service'
REPOSITORY_URL='https://github.com/manrodri/price-of-chair-deployment.git'

sudo  mkdir -p ${WORK_DIR}; sudo chown ubuntu:ubuntu ${WORK_DIR}
sudo mkdir ${LOG_DIR}; sudo chown ubuntu:ubuntu ${LOG_DIR}
sudo touch ${LOG_DIR}/emperor.log

sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt instal -y build-essential python3.7-dev python3-pip python3.7

sudo apt install -y python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools
cd ${WORK_DIR}; git clone ${REPOSITORY_URL} .

# install dependencies and create venv
python3 -m venv venv
source ./venv/bin/activate






