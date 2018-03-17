import boto3
import gzip
import json
import logging
import os
from botocore.vendored import requests
from StringIO import StringIO

def source_lists(event, context):
    ec2 = boto3.client('ec2')
    response_instance = ec2.describe_instances()
    print(response_instance)
