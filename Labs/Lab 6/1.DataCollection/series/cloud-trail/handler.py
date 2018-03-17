import boto3
import gzip
import json
import logging
import os
from StringIO import StringIO

client = boto3.client('dynamodb')

def create(event, context):
    encodedLogsData = str(event['Records'][0]['Sns']['Message'])
    decodedLogsData = gzip.GzipFile(fileobj = StringIO(encodedLogsData.decode('base64','strict'))).read()
    allEvents = json.loads(decodedLogsData)
    records = []
    for event in allEvents['logEvents']:
        analytics = sqs.send_message(
            QueueUrl= os.environ['DATA_LAKE_SERIES_QUEUE'],
            DelaySeconds=10,
            MessageAttributes = {
                'Identifier': {
                    'StringValue': 'CLOUDTRAIL',
                    'DataType': 'String'
                }},
            MessageBody=str(event['message']) + "\n"
            )

        data_lake = sqs.send_message(
            QueueUrl=os.environ['ANALYTICS_QUEUE_NAME'],
            DelaySeconds=10,
            MessageAttributes = {
                'Identifier': {
                    'StringValue': 'CLOUDTRAIL',
                    'DataType': 'String'
                }},
            MessageBody=str(event['message']) + "\n"
            )
