import json
import boto3
import logging
import re
import os

def lambda_handler(event, context):
    client = boto3.client('sns')
    try:
        logging.info("Starting parsing event")
        value = str(event['awslogs']['data'])
        logging.info(value)
        response = client.publish(
                TargetArn=os.environ['TargetSNS'],
                Message=value
            )
        logging.info('Ending parsing event')
        return response

    except Exception:
        logging.exception("Failed to push owasp-flowlog")
