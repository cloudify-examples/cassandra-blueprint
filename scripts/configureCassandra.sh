#!/bin/bash

set -e

node_type=$(ctx node type)

ctx logger info "configure ${node_type} BEGIN"

packages="cassandra21-tools datastax-agent dsc21 opscenter"

# check for java, even if not installed by package manager, if missing: add to install target list
java -version 2>&1 | egrep '1.[78]' > /dev/null || packages="java-1.8.0-openjdk $packages"

case $PLATFORM in
	deb)
		repoFile=/etc/apt/sources.list.d/cassandra.sources.list
		[ -e $repoFile ] || echo "deb http://debian.datastax.com/community stable main" >> $repoFile
		curl -L https://debian.datastax.com/debian/repo_key | apt-key add -
		apt-get update && apt-get install $packages
		;;
	rpm)
		repoFile=/etc/yum.repos.d/datastax.repo
		[ -e $repoFile ] || cat >> $repoFile <<- "EOF"
			[datastax] 
			name = DataStax Repo for Apache Cassandra
			baseurl = https://rpm.datastax.com/community
			enabled = 1
			gpgcheck = 0
			EOF
		yum -y install $packages
		chkconfig --add cassandra
		;;
	*)
		echo "invalid platform type (package manager format)" >&2
		exit 1
		;;
esac

ctx logger info "configure ${node_type} COMPLETED"
