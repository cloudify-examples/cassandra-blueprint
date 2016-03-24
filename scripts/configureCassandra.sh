#!/bin/bash
wrapped_script_for_sudo=`mktemp`
chmod +x $wrapped_script_for_sudo
echo '#!/bin/bash' > $wrapped_script_for_sudo
echo "PATH=$PATH" >> $wrapped_script_for_sudo
cat >> $wrapped_script_for_sudo << "wrapped_script_for_sudo_EOF"



ctx logger info "configure Cassandra BEGIN"

rm -rf /var/lib/cassandra
mkdir -p /var/lib/cassandra
chown cassandra:cassandra /var/lib/cassandra

cassandra_conf=`ls /etc/cassandra{,/conf}/cassandra.yaml 2> /dev/null`

seed=/etc/cassandra/cloudify-seed-ip
ip=`ctx instance host_ip`

if [ -e $seed ] ; then {

	seed=`cat $seed`

} ; else {

	seed=$ip

	mkdir -p /etc/opscenter/clusters
	cat >> /etc/opscenter/clusters/Test_Cluster.conf <<- EOF
		[jmx]
		username = 
		password = 
		port = 7199

		[agents]

		[cassandra]
		username = 
		seed_hosts = $seed
		password = 
		cql_port = 9042
		EOF

} ;  fi

sed -ri "s/^([ ]+- seeds: \")127.0.0.1(\".*)$/\1$seed\2/" $cassandra_conf
sed -ri "s/^(listen|rpc)(_address: )localhost(.*)$/\1\2$ip\3/" $cassandra_conf

cat >> /var/lib/datastax-agent/conf/address.yaml <<- EOF
	stomp_interface: $seed
	local_interface: $ip
	EOF

ctx logger info "configure Cassandra COMPLETED"



wrapped_script_for_sudo_EOF
sudo -E $wrapped_script_for_sudo
code=$?
rm $wrapped_script_for_sudo
exit $code
