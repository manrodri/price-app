from decimal import Decimal
import json
import boto3

session = boto3.Session(profile_name='acg')


def load_movies(movies):

    dynamodb = session.resource('dynamodb')

    table = dynamodb.Table('Movies')
    for movie in movies:
        year = int(movie['year'])
        title = movie['title']
        print("Adding movie:", year, title)
        table.put_item(Item=movie)


if __name__ == '__main__':
    with open("moviedata.json") as json_file:
        movie_list = json.load(json_file, parse_float=Decimal)
    load_movies(movie_list)