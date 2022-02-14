import boto3

session = boto3.Session(profile_name='acg')


def create_alert_table():
    dynamodb = session.resource('dynamodb')
    table = dynamodb.create_table(
        TableName='Alerts',
        KeySchema=[
            {
                'AttributeName': '_id',
                'KeyType': 'HASH'  # Partition key
            },
            {
                'AttributeName': 'user_email',
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
    alert_table = create_alert_table()
    print("Table status:", alert_table.table_status)
