sudo docker built -t price-app .
sudo docker run -d --name price -p 8080:80 \
-e ADMIN='lolo.edinburgh@gmail.com' \
-e MAILGUN_DOMAIN=sandboxd5230801a0404ef1b708a53dcc406251.mailgun.org \
-e MAILGUN_KEY=1db88cc77bbf9a477d1ccba74006fe0d-c3d1d1eb-62b81253 \
price-app