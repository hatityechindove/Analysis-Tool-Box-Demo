# Overview of conducting analysis for injested data
1. Create project for analysis
- Setup data, doc, R, Python and reports directories
2. Query data on Athena for Series Netflow logs
- Unique IP's that have traffic hit our VPC
3. Gather reputation dataset for IP's in dataset through
- Access Alien vault reputation dataset and store them
- Gather IP address from the reputation dataset
4. Identify IP intercepting between netflow and reputation dataset
5. Identify the reputation of the IP's that are intercepting
6. Identify the volume of traffic in the netflow that reputation in the different quaters
- Categorise in ACCEPT and DROP traffic
- Output summary of IP's to SNS (Percentiles)
7. Identify the potentially affected EC2 instances with the touching network cards (for ACCEPTED)
- Gather the network interfaces affected.
- Identify the machines using those interfaces
- Identify subnets affected
- Categorise by EC2 status
- Output summary of EC2 instances to SNS (Percentiles)
8. Presentation
8.1. Export code from notebooks to `*.py` that can be set to cron jobs or event jobs for starting analysis steps
or
8.2. Live notebook https://mybinder.org/ https://github.com/jupyterhub/binderhub
or
8.3. Anaconda enterprise deployment

9. Run batch https://medium.com/@devopsglobaleli/introduction-17b4d0c592b6

packages:
https://pypi.python.org/pypi/PyAthenaJDBC/
- pip install PyAthenaJDBC
