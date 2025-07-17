# HealthCheck

This collection of tools will be used to capture, view and alert on health status of various data sources.

### Architecture 
##### Data Collector (Remote Host)
- Remote server data collector will focus on Linux server root disk, MEM and CPU info.
- Save values as JSON file.
- Run every # of minutes, as set by cron job?
- Writing the script in PHP was easy because I could use PHP's json functions and Linux commands.

Example Output:
```
$ cat /tmp/healthcheck.json 
{
    "rootDiskSpaceUsedPercent": 11,
    "memTotalGB": 31,
    "memFreeGB": 23,
    "memUtilization": 74,
    "cpuCores": 4,
    "cpuUtilization": 2.86
}
```
##### Data Server (Remote Host)
- Python http server to share data from specific port on host. 
- Option to skip this custom Python http server and use NGNIX to server JSON file.
- Future Option, REST API? 

##### Data Aggregator and Validator (Main App)
- Program that reaches out the host URLS and reads JSON data.
- Check received health data if any values are outside of normal expected range.
	- Have expected range values in a separate text file to make things easy to configure?
- Check date on the received data to ensure fresh data. (Dead Man's Switch)
- Alert via:
    - Command Line? 
    - Email
    - Slack Channel
    - Text Message? 

##### Comments
The data being served via http from the remote host is preferred over SSH'ing into each host because that would require creating service accounts on each host and securing credentials on the main Data Aggregator and Validator host. 
In theory serving JSON health info doesn't divulge any private data. 

It might be worth investigating more secure ways of data transmission as well.
For example a one-way SSH "push" using SCP from each Linux host into the main Data Aggregator and Validator host.
Another could be having the Data Aggregator and Validator host share an NFS volume among the remote Linux hosts where they can simply copy the JSON data files.  
