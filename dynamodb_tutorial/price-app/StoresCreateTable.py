import boto3

session = boto3.Session(profile_name='jenkins')


def create_item_table(dynamodb=None):
    if not dynamodb:
        dynamodb = session.resource('dynamodb', endpoint_url='http://localhost:8000')
    table = dynamodb.create_table(
        TableName='Stores',
        KeySchema=[
            {
                'AttributeName': 'url_prefix',
                'KeyType': 'HASH'  # Partition key
            },
            {
                'AttributeName': 'name',
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
            }

        ],
        GlobalSecondaryIndexes=[
            {
                "IndexName": "name-index",
                "Projection": {"ProjectionType": "ALL"},
                "KeySchema": [
                    {
                        'AttributeName': 'name',
                        'KeyType': 'HASH'  # Partition key
                    }
                ],
                "ProvisionedThroughput": {
                    'ReadCapacityUnits': 1,
                    'WriteCapacityUnits': 1
                },

            }

        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 1,
            'WriteCapacityUnits': 1
        }
    )
    return table


if __name__ == '__main__':
    item_table = create_item_table(dynamodb=session.resource('dynamodb', endpoint_url='http://localhost:8000'))
    print("Table status:", item_table.table_status)
