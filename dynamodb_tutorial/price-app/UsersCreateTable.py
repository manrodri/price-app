import boto3

session = boto3.Session(profile_name="jenkins")

def create_user_table(dynamodb=None):


    if not dynamodb:
        dynamodb = boto3.resource('dynamodb', endpoint_url="http://localhost:8004")
    table = dynamodb.create_table(
        TableName='Users',
        KeySchema=[
            {
                'AttributeName': 'email',
                'KeyType': 'HASH'  # Partition key
            }
        ],
        AttributeDefinitions=[
            {
                'AttributeName': 'email',
                'AttributeType': 'S'
            }

        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 1,
            'WriteCapacityUnits': 1
        }
    )
    return table


if __name__ == '__main__':

    movie_table = create_user_table(session.resource("dynamodb"))
    print("Table status:", movie_table.table_status)
