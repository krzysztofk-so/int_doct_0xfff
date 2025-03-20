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
