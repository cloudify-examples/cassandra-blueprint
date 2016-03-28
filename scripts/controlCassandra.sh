#!/bin/bash
wrapped_script_for_sudo=`mktemp`
chmod +x $wrapped_script_for_sudo
echo '#!/bin/bash' > $wrapped_script_for_sudo
echo "PATH=$PATH" >> $wrapped_script_for_sudo
cat >> $wrapped_script_for_sudo << "wrapped_script_for_sudo_EOF"



ctx logger info "$command Cassandra BEGIN"

command=`ctx operation name | awk -F . '{print $NF}'`

log=/var/log/cassandra/system.log
msg='listening for.* clients'
listens=`cat $log 2> /dev/null | egrep -ic "$msg"`

service cassandra $command
[ -e /etc/cassandra/cloudify-seed-ip ] || service opscenterd $command
service datastax-agent $command

if [[ "$command" =~ start$ ]] ; then {
	while ! [ `cat $log 2> /dev/null | egrep -ic "$msg"` -gt $listens ] ; do sleep 1 ; done
	service datastax-agent restart
} ; fi

ctx instance runtime_properties last_command $command

ctx logger info "$command Cassandra COMPLETED"



wrapped_script_for_sudo_EOF
sudo -E $wrapped_script_for_sudo
code=$?
rm $wrapped_script_for_sudo
exit $code
