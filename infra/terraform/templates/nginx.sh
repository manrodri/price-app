sudo apt-get update -y; sudo apt-get -y install nginx

sudo cp /home/ubuntu/price-service.conf /etc/nginx/sites-available/price-service.conf
sudo ln -s /etc/nginx/sites-available/price-service.conf /etc/nginx/sites-enabled

sudo systemctl restart nginx