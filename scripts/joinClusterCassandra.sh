#!/bin/bash
wrapped_script_for_sudo=`mktemp`
chmod +x $wrapped_script_for_sudo
echo '#!/bin/bash' > $wrapped_script_for_sudo
echo "PATH=$PATH" >> $wrapped_script_for_sudo
cat >> $wrapped_script_for_sudo << "wrapped_script_for_sudo_EOF"



ctx target instance runtime_properties ip > /tmp/seed-ip



wrapped_script_for_sudo_EOF
sudo -E $wrapped_script_for_sudo
rm $wrapped_script_for_sudo
