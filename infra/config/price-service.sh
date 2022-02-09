#!/usr/bin/env bash

LOG_DIR='/var/log/price-service'
WORK_DIR='/var/www/html/price-service'
REPO_URL='https://github.com/manrodri/price-of-chair-deployment.git'

sudo mkdir -p ${WORK_DIR}
sudo chown ubuntu:ubuntu  ${WORK_DIR}

sudo mkdir ${LOG_DIR};
sudo chown ubuntu:ubuntu ${LOG_DIR}

cd ${WORK_DIR}
git clone --depth 1  ${REPO_URL}

# Install python, pipenv, nginx and dependencies
sudo apt-get update; sudo apt install -y python3 pipenv nginx
cd ${WORK_DIR}/price-of-chair-deployment
pipenv install

