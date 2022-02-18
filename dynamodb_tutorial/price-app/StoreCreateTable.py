import boto3

session = boto3.Session(profile_name='jenkins')


def create_store_table(dynamodb=None):
    if not dynamodb:
        dynamodb = session.resource('dynamodb', endpoint_url='http://localhost:8004')
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
                'AttributeName': 'name',
                'AttributeType': 'S'
            },
            {
                'AttributeName': 'url_prefix',
                'AttributeType': 'S'  # Sort key
            },

        ],

        ProvisionedThroughput={
            'ReadCapacityUnits': 1,
            'WriteCapacityUnits': 1
        }
    )
    return table


if __name__ == '__main__':
    store_table = create_store_table(dynamodb=session.resource('dynamodb'))
    print("Table status:", store_table.table_status)
