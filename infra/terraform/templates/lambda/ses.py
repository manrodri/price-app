import os

import boto3
from botocore.exceptions import ClientError


class SesException(BaseException):
    def __init__(self, message):
        self.message = message


class Ses:
    SMTP_USERNAME = os.environ.get('smtp_username', None)
    SMTP_PASSWORD = os.environ.get('smtp_password', None)
    AWS_REGION = os.environ.get('region')
    CHARSET = "UTF-8"

    @classmethod
    # todo add html to email https://docs.aws.amazon.com/ses/latest/dg/send-an-email-using-sdk-programmatically.html
    def send_email(cls, sender: str, recipient: str, subject: str, text: str):
        if cls.SMTP_USERNAME is None:
            raise SesException("Failed to load SMTP_USERNAME")
        if cls.SMTP_PASSWORD is None:
            raise SesException("Failed to load SMTP_PASSWORD")

        session = boto3.Session(region_name=cls.AWS_REGION)
        client = session.client('ses')
        try:
            response = client.send_email(
                Destination={
                    'ToAddresses': [
                        recipient,
                    ],
                },
                Message={
                    'Body': {
                        'Text': {
                            'Charset': cls.CHARSET,
                            'Data': text,
                        },
                    },
                    'Subject': {
                        'Charset': cls.CHARSET,
                        'Data': subject,
                    },
                },
                Source=sender,

            )
        # Display an error if something goes wrong.
        except ClientError as e:
            print(e.response['Error']['Message'])
        else:
            print("Email sent! Message ID:"),
            print(response['MessageId'])
            return response


def lambda_handler(event, context):
    ses = Ses()

    message = event['message']

    recipient = message['recipient']
    sender = message['sender']
    subject = message['subject']
    text = message['text']

    response = ses.send_email(sender, recipient, subject, text)
    return {
        "statusCode": 200,
        "body": f"Email sent! Message ID:  {response['MessageId']}",
        "headers": {
            "Access-Control-Allow-Origin": "*"
        }
    }
