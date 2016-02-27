#!/bin/bash

set -e

node_type=$(ctx node type)

command=`ctx operation name | awk -F . '{print $NF}'`

ctx logger info "$command ${node_type} BEGIN"

service cassandra $command

ctx logger info "$command ${node_type} COMPLETED"
