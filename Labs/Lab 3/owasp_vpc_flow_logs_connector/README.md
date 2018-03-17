# Flow Log capture for the Default VPC
1. Create data leak stream for flow logs
- Create aws_s3_bucket for data_lake_store
- Create aws_athena_database
- Create aws_s3_bucket for owasp_infra_firehose_bucket
- Create owasp_infra_firehose_role
- Create aws_kinesis_firehose_delivery_stream for owasp_flow_log_stream
