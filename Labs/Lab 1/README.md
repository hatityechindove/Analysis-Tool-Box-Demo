## Set up a series stream for netflow logs manually

*https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/flow-logs.html*
1. Under IAM create an IAM flow log role to trust EC2
- Add inline policy for cloud watch called owasp flow logs
` {
    "Version": "2012-10-17",
    "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
    ]
    }
`
- Update trust relationship for owasp-netflow to have a vpc-flow-logs principle
`
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "",
          "Effect": "Allow",
          "Principal": {
            "Service": "vpc-flow-logs.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
`
2. Create a log flow group called `owasp-test` as a destination for flow logs. Set expiration of events to a day

3. Under VPC, create flow logs for your targeted VPC (same for subnets)
- Select your VPC and go to the Flow logs tab then select `Create flow log`
- For role, select the `owasp-netflow` role you created earlier
- For log group select the group created called `owasp-test`

You how have VPC flow logs going to you cloud watch.
`2 032939679065 eni-b6d50962 64.22.152.115 10.10.10.124 8443 58480 6 1 40 1521112128 1521112185 ACCEPT OK`

## Setup from collection to a processing subscriber
1. Under SNS, create simple notification service topic to stream cloud watch logs to called `owasp-flowlog-stream`.
2. Under IAM, create a role called `owasp-flow-lambda-execution` with a `lambda` trust entity and add the inline policy below to allow access to sns and cloudwatch with policy name `owasp-flow-lambda-policy`:

`
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "Stmt1507040455000",
                "Effect": "Allow",
                "Action": [
                    "sns:ListSubscriptions",
                    "sns:ListSubscriptionsByTopic",
                    "sns:ListTopics",
                    "sns:Publish",
                    "sns:Subscribe",
                    "sns:Unsubscribe"
                ],
                "Resource": [
                    "*"
                ]
            },

            {
                "Effect": "Allow",
                "Action": [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Resource": "arn:aws:logs:*:*:*"
            }
        ]
    }
`

2. Under Lambda create runtime `python 2.7` function called `owasp-flow-logs` from scratch with the role `owasp-flow-lambda-execution` created above and add this code
`
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
                    TargetArn='arn:aws:sns:[REGION]:[ACOUNT_ID]:owasp-flowlog-stream',
                    Message=value
                )
            logging.info('Ending parsing event')
            return response

        except Exception:
            logging.exception("Failed to push owasp-flowlog-stream")
`
- Replaces the `TargetARN` with the ARN for the SNS created on the first step. This will write logs to that sns topic
- Add a Cloudwatch log trigger to the lambda as the `owasp-test` which was created in setting up the stream.

* To test setup, subscribe the sns to a queue (SNS) of your choosing *

## Set up context stream for ec2 descriptors
