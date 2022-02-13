sudo chmod a+x mongo.sh price-app.sh nginx.sh
sudo ./mongo.sh; sudo ./price-app.sh

sudo cp /home/ubuntu/env.conf  /var/www/html/price-service/env.conf
sudo cp /home/ubuntu/price-service.service /etc/systemd/system/

sudo ./nginx.sh


