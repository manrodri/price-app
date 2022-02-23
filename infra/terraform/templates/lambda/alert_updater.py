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
    content = request.content
    logger.info(f"content: {content}")

    # query: has to be a dict? what is comming from dynamo is a string

    soup = BeautifulSoup(content, "html.parser")
    element = soup.find(item["tag_name"], item["query"])
    logger.info(f"element: {element}")
    string_price = element.text.strip()

    pattern = re.compile(r"(\d+,?\d+\.\d+)")
    match = pattern.search(string_price)
    found_price = match.group(1)
    without_commas = found_price.replace(",", "")
    price = float(without_commas)
    return price


def notify_if_price_reached(alert):
    logger.info(f"alert: {alert}")
    item_id = alert['item_id']
    item = get_item(item_id)

    if float(item.get('price')) < float(alert.get('price_limit')):
        text = f"Item {item.get('url')} has reached a price under {alert.get('price_limit')}. Latest price: {item.get('price')}."

        Ses.send_email(
            sender=os.environ.get('SENDER'),
            recipient=os.environ.get('RECIPIENT'),
            subject=os.environ.get('SUBJECT'),
            text=text
        )


def lambda_handler(event, context):
    alerts = all_alerts()
    for alert in alerts:
        load_item_price(alert['item_id'])
        notify_if_price_reached()

    if not alerts:
        print("No alerts have been created. Add an item and an alert to begin!")
