import boto3

session = boto3.Session(profile_name='jenkins')


def create_alert_table(dynamodb=None):
    if not dynamodb:
        dynamodb = session.resource('dynamodb', endpoint_url='http://localhost:8004')
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
            },

        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 1,
            'WriteCapacityUnits': 1
        }
    )
    return table


if __name__ == '__main__':
    alert_table = create_alert_table(session.resource('dynamodb'))
    print("Table status:", alert_table.table_status)
