import boto3

session = boto3.Session(profile_name='acg')


def create_store_table():
    dynamodb = session.resource('dynamodb')
    table = dynamodb.create_table(
        TableName='Stores',
        KeySchema=[
            {
                'AttributeName': 'name',
                'KeyType': 'HASH'  # Partition key
            },
            {
                'AttributeName': 'url_prefix',
                'KeyType': 'RANGE'  # Sort key
            },
        ],
        AttributeDefinitions=[
            {
                'AttributeName': 'url_prefix',
                'AttributeType': 'S'
            },
            {
                'AttributeName': 'name',
                'AttributeType': 'S'
            },

        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 1,
            'WriteCapacityUnits': 1
        }
    )
    return table


if __name__ == '__main__':
    store_table = create_store_table()
    print("Table status:", store_table.table_status)
