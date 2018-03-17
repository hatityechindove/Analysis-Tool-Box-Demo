## Objective to push logs to a data lake for future analysis
1. Create flow logs Series pool
- Terraform
2. Create a consumer service from data collection and push to series pool
- Serverless
3. Add a query interface to the series pool
- Athena (Simba connector can be a good service to use)
4. Create ec2 instance Context pool
- Terraform
5. Create a consumer service from data collection to push to context pool
- serverless
6. Add a query interface to the context pool
- Athena
