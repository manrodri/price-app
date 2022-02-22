import os

import boto3
from botocore.exceptions import ClientError


class SesException(BaseException):
    def __init__(self,message):
        self.message = message

class Ses:
    SMTP_USERNAME = os.environ.get('smtp_username', None)
    SMTP_PASSWORD = os.environ.get('smtp_password', None)
    AWS_REGION = 'us-east-1'

    FROM_TITLE = 'Pricing service'
    FROM_EMAIL = f'do-not-reply@PRICE_APP_SERVICE'
    SUBJECT = "Amazon SES Test (SDK for Python)"
    CHARSET = "UTF-8"

    @classmethod
    # todo add html to email https://docs.aws.amazon.com/ses/latest/dg/send-an-email-using-sdk-programmatically.html
    def send_email(cls, sender:str, recipient: str, subject: str, text: str):
        if cls.SMTP_USERNAME is None:
            raise SesException("Failed to load SMTP_USERNAME")
        if cls.SMTP_PASSWORD is None:
            raise SesException("Failed to load SMTP_PASSWORD")

        session = boto3.Session(region_name=os.environ['region'])
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
