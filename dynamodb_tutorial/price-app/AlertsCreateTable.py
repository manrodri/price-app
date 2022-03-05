import boto3

session = boto3.Session(profile_name='jenkins')


def create_item_table(dynamodb=None):
    if not dynamodb:
        dynamodb = session.resource('dynamodb', endpoint_url='http://localhost:8000')
    table = dynamodb.create_table(
        TableName='Alerts',
        KeySchema=[
            {
                'AttributeName': 'user_email',
                'KeyType': 'HASH'  # Partition key
            },
            {
                'AttributeName': '_id',
                'KeyType': 'RANGE'  # Sort key
            },
        ],
        AttributeDefinitions=[
            {
                'AttributeName': 'user_email',
                'AttributeType': 'S'
            },
            {
                'AttributeName': '_id',
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
    item_table = create_item_table(dynamodb=session.resource('dynamodb', endpoint_url='http://localhost:8000'))
    print("Table status:", item_table.table_status)