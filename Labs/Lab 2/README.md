## Using the terraform enable vpc flow log (folder: flow-log-logger)
1. Create main terraform files
`main.tf`
2. Complete set of configuration for vpc
3. Run `terraform init`
4. Run `terraform plan`
5. Run `terraform apply`
6. Collect names of all the cloudwatch log groups that are receiving flowlogs for use in the next section

## Using the serverless framework to create flow log collection (folder owasp-flow-log-collector)
1. Create collection components using serverless framework
`serverless create --template aws-python --path owasp-flow-log-collector`
2. Create resources in the `serverless.yml` file
3. Set environment variables in the `serverless.env.yml` file
4. Capture flow logs names as subscribers and update the `serverless.env.yml` file and the `serverless.yml` accordingly
4. Setup up processing code in the `hander.py` file
5. Deploy the service


You can test the deploy by checking whether the queue will subscribe to the topic
