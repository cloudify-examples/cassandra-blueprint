#!/bin/bash
wrapped_script_for_sudo=`mktemp`
chmod +x $wrapped_script_for_sudo
echo '#!/bin/bash' > $wrapped_script_for_sudo
echo "PATH=$PATH" >> $wrapped_script_for_sudo
cat >> $wrapped_script_for_sudo << "wrapped_script_for_sudo_EOF"



seed=`ctx target instance host_ip`
echo $seed > /etc/cassandra/cloudify-seed-ip
while ! [[ "$(ctx target instance runtime_properties last_command)" =~ start$ ]] ; do sleep 1 ; done



wrapped_script_for_sudo_EOF
sudo -E $wrapped_script_for_sudo
code=$?
rm $wrapped_script_for_sudo
exit $code
