docker run -d -p 5000:5000 \
-e DB_CONNECTION_STRING="mongodb://127.0.0.1:27017/price-app" \
--name price-service docker.io/manrodri/price-service:0.1