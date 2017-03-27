[![Build Status](https://circleci.com/gh/cloudify-examples/cassandra-blueprint.svg?style=shield&circle-token=:circle-token)](https://circleci.com/gh/cloudify-examples/cassandra-blueprint)

# demoCassandraBlueprint
a Cloudify blueprint to demonstrate orchestrating a Cassandra cluster

## Features
* Deploys a cluster of DataStax Community distribution of Apache Cassandra™ 2.1
* Cluster created in an Amazon VPC environment with customizable Security Group
* Supports both RPM based (RHEL, CentOS) and DEB based (Ubuntu) configurations
* Also installs DataStax OpsCenter for cluster visualization and monitoring
* Supports the scale workflow of Cloudify to expand the Cassandra cluster on demand

## Requirements
* Cloudify version 3.4
* AWS plugin version 1.4.4
  * Cloudify 3.3.0 and AWS plugin 1.3 are insufficient as they lack VPC support

### Step 1: Upload the blueprint

`cfy blueprints upload -b cassandra -p blueprint.yaml`

### Step 2: Create a deployment

After you filled the input file with your inputs, run:

`cfy deployments create -b cassandra -i inputs.yaml -d dep1`

### Step 3: Install

Once the deployment is created, we can start running workflows:

`cfy executions start -d dep1 -w install`

## Scaling
* The cluster will consist of one seed node and one or more peer nodes
  * By default, it will start as a 2 node cluster: 1 seed and 1 peer node
* A running cluster can be expanded after deployment
  * To do so, execute the scale workflow built in to Cloudify with cassandra_peer_host as the node_id
  * Apply a positive delta to increase or negative delta in order to decrease cluster nodes

### Step 4: Scale up / Scale down

For scaling down simply change the delta to -1 (or any other number as you need)

`cfy executions start -d dep1 -w scale -p 'scalable_entity_name=cassandra_peer_host;delta=1'`

### Step 5: Uninstall

`cfy executions start -d dep1 -w uninstall`
