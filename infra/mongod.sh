ROOT_DATA_DIR='/Users/manuelrodriguez/dev/PYTHON/price-app'
DATA_DIR="${ROOT_DATA_DIR}/data"
export DB_CONNECTION_STRING="mongodb://127.0.0.1:27017/price-app"

mongod --dbpath=${DATA_DIR}


export db_user=db_admini
export db_password=CrJKaHXDP7js5nDc

#mongodb+srv://db_admini:CrJKaHXDP7js5nDc@cluster0.eazeo.mongodb.net/test