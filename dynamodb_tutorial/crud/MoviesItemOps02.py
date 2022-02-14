import boto3
from botocore.exceptions import ClientError

session = boto3.Session(profile_name='acg')


def get_movie(title, year):
    dynamodb = session.resource('dynamodb')

    table = dynamodb.Table('Movies')

    try:
        response = table.get_item(Key={'year': year, 'title': title})
    except ClientError as e:
        print(e.response['Error']['Message'])
    else:
        return response['Item']


if __name__ == '__main__':
    movie = get_movie("The Big New Movie", 2015, )
    if movie:
        print("Get movie succeeded:")
    print(movie)
