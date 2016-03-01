#!/bin/bash

ctx logger info "configure Cassandra BEGIN"

case $PLATFORM in
	deb)
		repoFile=/etc/apt/sources.list.d/cassandra.sources.list
		[ -e $repoFile ] || echo "deb http://debian.datastax.com/community stable main" >> $repoFile
		curl -L https://debian.datastax.com/debian/repo_key | apt-key add -
		packages="cassandra-tools=2.1.13 datastax-agent dsc21 opscenter cassandra=2.1.13"
		java -version 2>&1 | egrep '1.[78]' > /dev/null || packages="openjdk-7-jre-headless $packages"
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
		packages="cassandra21-tools datastax-agent dsc21 opscenter"
		java -version 2>&1 | egrep '1.[78]' > /dev/null || packages="java-1.7.0-openjdk-headless $packages"
		yum -y install $packages
		chkconfig --add cassandra
		;;
	*)
		echo "invalid platform type (package manager format)" >&2
		exit 1
		;;
esac

ctx logger info "configure Cassandra COMPLETED"
