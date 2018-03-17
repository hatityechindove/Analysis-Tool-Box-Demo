# Datalake database
resource "aws_s3_bucket" "data_lake_store" {
  bucket = "owasp.data-lake.store"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {

  id      = "log"
  enabled = true
  prefix  = "log/"

  transition {
    days          = 120
    storage_class = "STANDARD_IA"
  }

  transition {
    days          = 365
    storage_class = "GLACIER"
  }

  expiration {
    days = 1825
  }
 }
}

resource "aws_athena_database" "owasp_data_lake_db" {
  name = "owasp_data_lake_db"
  bucket = "${aws_s3_bucket.data_lake_store.bucket}"
}


## Time Series ###
# VPC flow Logs
resource "aws_s3_bucket" "owasp_flow_logs_firehose_bucket" {
  bucket = "owasp.logs.flowlogs"
  acl    = "private"
}

resource "aws_iam_role" "owasp_infra_firehose_role" {
  name = "owasp_infra_firehose_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_kinesis_firehose_delivery_stream" "owasp_flow_log_stream" {
  name        = "owasp_flow_log_stream"
  destination = "s3"

  s3_configuration {
    role_arn   = "${aws_iam_role.owasp_infra_firehose_role.arn}"
    bucket_arn = "${aws_s3_bucket.owasp_flow_logs_firehose_bucket.arn}"
    cloudwatch_logging_options {
        enabled = true
        log_group_name = "/aws/kinesisfirehose/owasp_flow_log_stream"
        log_stream_name = "S3Delivery"
    }
  }
}
