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
  * Cloudify 3.3.0 and AWS plugin 1.3 are insufficient as they lack VPC support

## Scaling
* The cluster will consist of one seed node and one or more peer nodes
* The input variable init_num_peer_hosts controls how many peer nodes the cluster will start with
* Leaving its value at the default of 1 will result in a 2 node cluster: 1 seed and 1 peer node
* A running cluster can always be expanded after deployment, regardless of init_num_peer_hosts
* To do so, execute the scale workflow built in to Cloudify with cassandra_peer_host as the node_id
* The scale workflow can also apply a negative delta in order to decrease cluster nodes
