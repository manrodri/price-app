- mkdir and change permissions

    - `$ sudo  mkdir -p /var/www/html/price-service; sudo chown ubuntu:ubuntu /var/www/html/price-service`
    - `$ sudo mkdir /var/log/price-service; sudo chown ubuntu:ubuntu /var/log/price-service`
    - `cd /var/log/html/price-service; git clone $repository_url; cd price-tracking-app`
    
- Install python and pipenv then install dependencies

  - `$ sudo apt-get update; sudo apt install -y python3 pipenv nginx`
  - `$ pipenv install`
  
- Get secrets from SecretsManager and set variables

- Make sure creates log files (must be accessible by ubuntu user)
- Systemctl daemon-relog
- Systemct start service and enjoy trouble shooting
- Configure nginx