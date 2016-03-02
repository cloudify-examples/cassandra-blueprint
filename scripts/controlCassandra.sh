#!/bin/bash
wrapped_script_for_sudo=`mktemp`
chmod +x $wrapped_script_for_sudo
echo '#!/bin/bash' > $wrapped_script_for_sudo
echo "PATH=$PATH" >> $wrapped_script_for_sudo
cat >> $wrapped_script_for_sudo << "wrapped_script_for_sudo_EOF"



command=`ctx operation name | awk -F . '{print $NF}'`

ctx logger info "$command Cassandra BEGIN"

service cassandra $command
[ -e /tmp/seed-ip ] || service opscenterd $command

ctx logger info "$command Cassandra COMPLETED"



wrapped_script_for_sudo_EOF
sudo -E $wrapped_script_for_sudo
rm $wrapped_script_for_sudo
