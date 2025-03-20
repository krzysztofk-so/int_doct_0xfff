To monitor multiple Ubuntu production instances, I would implement a comprehensive monitoring strategy that includes the following components:




1) Centralized Monitoring System:
I would use a centralized monitoring tool like Prometheus, Zabbix, or New Relic to collect and visualize metrics from all instances. I primarily use Prometheus and Grafana, as well as New Relic.

This allows for real-time monitoring and alerting. The main idea is to have metrics where we can track CPU, disk, memory, processes, and network metrics such as bandwidth, traffic, and process counts. It is advisable to keep these metrics for at least 14 days to have a good reference.

I would install Prometheus and Grafana on a central monitoring server, with scripts to check the availability of the monitoring server. For example, I would send a heartbeat every 5 minutes to the UptimeRobot endpoint. If no heartbeat is received, I would send an alert to Slack, Teams, or email, depending on our communication tools.
Install Prometheus Node Exporter on each Ubuntu node.
Configure Prometheus to scrape metrics from each node.
For example, to scrape metrics, I would configure Prometheus as follows:


global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['<node1-ip>:9100', '<node2-ip>:9100', '<node3-ip>:9100']

I would configure Prometheus to scrape the nodeexpoerter endpoint.

2) Log Management:
I would use Loki and Promtail so that we can load logs into Grafana, allowing developers to easily access Grafana and filter the logs. I find New Relic also very useful for quickly sending and filtering logs.

We could also use the ELK Stack (Elasticsearch, Logstash, and Kibana), though I am not a big fan of that setup.

I would install Loki on the centralized monitoring server, where Prometheus and Grafana are also installed.
Promtail would be installed on each node with the endpoint pointing to Loki, so logs can be pushed from each node. I would restrict the logs so that only the necessary application and system logs are collected (e.g., /var/log/*).


4) Alerting:
For metrics like CPU, memory, disk utilization, and uptime, I would create metrics for each node in Grafana and set up alerts based on thresholds. Warnings would be triggered when usage is between 85% and 90%, and critical alerts would be triggered when usage exceeds 90% to 95%.

The goal is to minimize false alerts. Often, when CPU and memory utilization reaches around 90%, the system tends to slow down, and this is a sign that close attention is needed, as it could soon become unresponsive.


depending also what is running on these machines, it could be for nginx or database, I would create also scripts on the central monitoring that would check all of the endpoints if they were in the private netowrk if not I would conider maybe uptime robot.

For mysql also I would track process, as a part of monitoring, keealive aslo might be a good solution for the failover option that tracks and observe network interfaces.










1) Centralized Monitoring System:

I would use a centralized monitoring tool like Prometheus or zabbix ornewrelic to collect and visualize metrics from all instances. 

Mainly I use prometheus and Grafana and also Newrelic.

This allows for real-time monitoring and alerting.
So the main Idea is to have metric where we can see cpu,disk,memory,processes,network like bandwith, amount
of traffic and processes. And it is good to keep them at least for 14 days to have some kin dof reference

- I would Install Prometheus and grafana on a Central Server monitoring server with some scripts to check the central monitoring server avaiblity. E.g: I would send a heart bit every 5 min to UptimeRobot endpoint. If there is not heartbit I would send an alert to Slack or Teams or e-mail depeding what we use.
- Install Prometheus Node Exporter on Each Node - ubuntu
- Configure Prometheus to Scrape Metrics from Each Node
- in order to scrape metric I would apply just an example:
global:
     scrape_interval: 15s

   scrape_configs:
     - job_name: 'node_exporter'
       static_configs:
         - targets: ['<node1-ip>:9100', '<node2-ip>:9100', '<node3-ip>:9100']


- I would choose to scrape prometheus endpoint 



2) Log Management:

I would use loki and promtail so I can load them in grafana so developers can easily access grafana and filter.
I find Newrelic also very handy as you can send and filter very fast the logs

we could also use ELK stack (elastic search, logstash and kibana) - not a big fun of that though


- So I would install loki also on the centralize monitoring server, where prometheus and grafana are.
- promtail would be installed on each of the node with the endpoint to loki so we could push them. I would restrict the logs so only some parts of them needed for the applications and system logse.g: var/logs/* 


4) Alerting, for the metrics like CPU, MEMory, disk utilization, uptime, I would create a metrics for each of the node in Grafana and set up alerts based on the treshhold, warning would be between 85 - 90 and critical from 90 - 95. I would like to minialize the noise and very often when the CPU and Memory are running on this level like 90% system is getting slow and for me is a sign that I need to closly paying attantion as it could get unresposive soon.