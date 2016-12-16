#!/bin/bash

# instructions found at
# https://mattwilcox.net/web-development/unexpected-ddos-blocking-china-with-ipset-and-iptables

# Download this script and run it




wget -P https://raw.githubusercontent.com/bobbybrooks/firewall-stuff/master/iptables.firewall.rules
sudo mv iptables.firewall.rules /etc/iptables.firewall.rules


# Apply the firewall rules
sudo iptables-restore < /etc/iptables.firewall.rules

# This ensures it's run every time the system boots
sudo echo '#!/bin/sh' > /etc/network/if-pre-up.d/firewall
sudo echo '/sbin/iptables-restore < /etc/iptables.firewall.rules' >>  /etc/network/if-pre-up.d/firewall
sudo chmod +x /etc/network/if-pre-up.d/firewall

# Download and install ipset
sudo apt-get install ipset -y

# This is where we start blocking China
wget -P https://raw.githubusercontent.com/bobbybrooks/firewall-stuff/master/block-china.sh .
sudo mv block-china.sh /etc/
sudo chmod +x /etc/block-china.sh
# Now let's run it
/etc/block-china.sh

echo
echo 'To make this automatic'
echo 'run "crontab -e"'
echo 'and add a line like this'
echo '* 5 * * * /etc/block-china.sh'
echo 'This will run /etc/block-china.sh at 5am every day'

