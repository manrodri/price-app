#!/usr/bin/env bash

## Install python, pipenv and nginx

WORK_DIR="/var/www/html/price-service"
LOG_DIR='/var/log/price-service'
REPOSITORY_URL='https://github.com/manrodri/price-of-chair-deployment.git'

sudo  mkdir -p ${WORK_DIR}; sudo chown ubuntu:ubuntu ${WORK_DIR}
sudo mkdir ${LOG_DIR}; sudo chown ubuntu:ubuntu ${LOG_DIR}

sudo apt-get update; sudo apt install -y python3 pipenv nginx git

cd ${WORK_DIR}; git clone ${REPOSITORY_URL} && cd price-of-chair-deployment

# install dependencies and create venv

pipenv --python $(which python3)
pipenv shell
pipenv install
python ./app.py




