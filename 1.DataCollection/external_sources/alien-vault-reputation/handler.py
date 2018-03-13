import boto3
import gzip
import json
import logging
import os
from botocore.vendored import requests
from StringIO import StringIO

def source_lists(event, context):
    target_url = os.environ['SOURCE_URL']
    reputation_file = requests.get(target_url)
    reputations = str(reputation_file.text).split('\n')[:-1]
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(os.environ['IP_REPUTATION_TABLE'])
    with table.batch_writer() as batch:
        for reputation_set in reputations:
            reputation = reputation_set.split('#')
            batch.put_item(
                Item={
                    'IP': reputation[0] if len(reputation[0]) != 0 else 'NaN',
                    'Reliability' : int(reputation[1]) if len(reputation[1]) != 0 else 0,
                    'Risk': int(reputation[2]) if len(reputation[2]) != 0 else 0,
                    'Type' :reputation[3] if len(reputation[3]) != 0 else 'NaN',
                    'Country' : reputation[4] if len(reputation[4]) != 0 else 'NaN',
                    'Locale' : reputation[5]  if len(reputation[5]) != 0 else 'NaN',
                    'Coords' : reputation[6]  if len(reputation[6]) != 0 else 'NaN',
                    'X' : int(reputation[7]) if len(reputation[7]) != 0 else 0
                })
