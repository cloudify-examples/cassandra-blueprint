#!/bin/bash
wrapped_script_for_sudo=`mktemp`
chmod +x $wrapped_script_for_sudo
echo '#!/bin/bash' > $wrapped_script_for_sudo
echo "PATH=$PATH" >> $wrapped_script_for_sudo
cat >> $wrapped_script_for_sudo << "wrapped_script_for_sudo_EOF"



ctx logger info "$command Cassandra BEGIN"

command=`ctx operation name | awk -F . '{print $NF}'`

[ -e /etc/cassandra/cloudify-seed-ip ] || service opscenterd $command
service cassandra $command
service datastax-agent $command

ctx instance runtime_properties last_command $command

ctx logger info "$command Cassandra COMPLETED"



wrapped_script_for_sudo_EOF
sudo -E $wrapped_script_for_sudo
code=$?
rm $wrapped_script_for_sudo
exit $code
