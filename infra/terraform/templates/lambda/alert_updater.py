import json
import os
import re
from typing import List

from boto3.dynamodb.conditions import Key
from botocore.exceptions import ClientError
import requests
from bs4 import BeautifulSoup
import logging

import boto3

from ses import Ses


logger = logging.getLogger()
logger.setLevel(logging.INFO)

# all I need is to get Alerts from dynamo and send message

session = boto3.Session(region_name=os.environ['region'])
resource = session.resource('dynamodb')
table = resource.Table("Alerts")


def get_item(item_id):
    session = boto3.Session(region_name=os.environ['region'])
    resource = session.resource('dynamodb')
    table = resource.Table("Items")

    try:
        response = table.query(
            KeyConditionExpression=Key("_id").eq(item_id)
        )
    except ClientError as e:
        print(e.response['Error']['Message'])
        raise ClientError
    else:
        if len(response["Items"]) == 0:
            raise IndexError

        return response['Items'][0]


def all_alerts():
    session = boto3.Session(region_name=os.environ['region'])
    resource = session.resource('dynamodb')
    table = resource.Table("Alerts")
    try:
        response = table.scan()
    except ClientError as e:
        print(e.response['Error']['Message'])
        raise ClientError

    logger.info(f"alerts: {response['Items']}")

    return response['Items']


#todo not working when running in lambda environment
def load_item_price(item_id):
    logger.info(f"item_id: {item_id}")
    item = get_item(item_id)
    logger.info(f"item: {item}")

    request = requests.get(item["url"])
    # query: has to be a dict? what is coming from dynamo is a string
    query = json.loads(item['query'])
    content = request.content
    logger.info(f"content: {content}")


    soup = BeautifulSoup(content, "html.parser")
    element = soup.find(item["tag_name"], query)
    string_price = element.text.strip()

    pattern = re.compile(r"(\d+,?\d+\.\d+)")
    match = pattern.search(string_price)
    found_price = match.group(1)
    without_commas = found_price.replace(",", "")
    price = float(without_commas)
    return item


def notify_if_price_reached(alert, item):

    if float(item.get('price')) < float(alert.get('price_limit')):
        text = f"Item {item.get('url')} has reached a price under {alert.get('price_limit')}. Latest price: {item.get('price')}."

        recipient = os.environ.get('RECIPIENT')
        Ses.send_email(
            sender=os.environ.get('SENDER'),
            recipient=recipient,
            subject=os.environ.get('SUBJECT'),
            text=text
        )
        logger.info(f"email sent to: {recipient}")


def lambda_handler(event, context):
    alerts = all_alerts()
    for alert in alerts:
        item = load_item_price(alert['item_id'])
        notify_if_price_reached(alert, item)

    if not alerts:
        print("No alerts have been created. Add an item and an alert to begin!")
