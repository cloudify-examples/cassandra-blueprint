# demoCassandraBlueprint
a Cloudify blueprint to demonstrate orchestrating a Cassandra cluster

## Features
* Deploys a cluster of DataStax Community distribution of Apache Cassandra™ 2.1
* Cluster created in an Amazon VPC environment with customizable Security Group
* Supports both RPM based (RHEL, CentOS) and DEB based (Ubuntu) configurations
* Also installs DataStax OpsCenter for cluster visualization and monitoring
* Supports the scale workflow of Cloudify to expand the Cassandra cluster on demand

## Requirements
* Cloudify version 3.3.1
* AWS plugin version 1.4
  * Cloudify 3.3.0 and AWS plugin 1.3 are not supported
