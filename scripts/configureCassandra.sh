#!/bin/bash
wrapped_script_for_sudo=`mktemp`
chmod +x $wrapped_script_for_sudo
echo '#!/bin/bash' > $wrapped_script_for_sudo
echo "PATH=$PATH" >> $wrapped_script_for_sudo
cat >> $wrapped_script_for_sudo << "wrapped_script_for_sudo_EOF"



ctx logger info "configure Cassandra BEGIN"

case $PLATFORM in
	deb)
		repoFile=/etc/apt/sources.list.d/cassandra.sources.list
		[ -e $repoFile ] || echo "deb http://debian.datastax.com/community stable main" >> $repoFile
		curl -L https://debian.datastax.com/debian/repo_key | apt-key add -
		packages="cassandra-tools=2.1.13 datastax-agent dsc21 opscenter cassandra=2.1.13"
		java -version 2>&1 | egrep '1.[78]' > /dev/null || packages="openjdk-7-jre-headless $packages"
		apt-get update
		apt-get -y install $packages
		service cassandra stop
		cassandra_conf=/etc/cassandra/cassandra.yaml
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
		cassandra_conf=/etc/cassandra/conf/cassandra.yaml
		;;
	*)
		echo "invalid platform type (package manager format)" >&2
		exit 1
		;;
esac

rm -rf /var/lib/cassandra/*

if [ -e /tmp/seed-ip ] ; then {

	ip=`ctx instance runtime_properties ip`
	seed=`cat /tmp/seed-ip`
	sed -ri "s/^([ ]+- seeds: \")127.0.0.1(\".*)$/\\1$seed\\2/" $cassandra_conf
	sed -ri "s/^(listen_address: )localhost(.*)$/\1$ip\2/" $cassandra_conf
	sed -ri "s/^(rpc_address: )localhost(.*)$/\10.0.0.0\2/" $cassandra_conf

} ; else {

	mkdir -p /etc/opscenter/clusters
	cat >> /etc/opscenter/clusters/Test_Cluster.conf <<- "EOF"
	[jmx]
	username = 
	password = 
	port = 7199

	[agents]

	[cassandra]
	username = 
	seed_hosts = 127.0.0.1
	password = 
	cql_port = 9042
	EOF
	ip=`ctx instance runtime_properties ip`
	sed -ri "s/127.0.0.1/$ip/" /etc/opscenter/clusters/Test_Cluster.conf
	seed=$ip
	sed -ri "s/^([ ]+- seeds: \")127.0.0.1(\".*)$/\\1$seed\\2/" $cassandra_conf
	sed -ri "s/^(listen_address: )localhost(.*)$/\1$ip\2/" $cassandra_conf
	sed -ri "s/^(rpc_address: )localhost(.*)$/\10.0.0.0\2/" $cassandra_conf

} ;  fi

ctx logger info "configure Cassandra COMPLETED"



wrapped_script_for_sudo_EOF
sudo -E $wrapped_script_for_sudo
rm $wrapped_script_for_sudo
