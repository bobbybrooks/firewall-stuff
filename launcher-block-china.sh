#!/bin/bash

# instructions found at
# https://mattwilcox.net/web-development/unexpected-ddos-blocking-china-with-ipset-and-iptables

# Download this script and run it



# pulling down the firewall rules file
wget -P . https://raw.githubusercontent.com/bobbybrooks/firewall-stuff/master/iptables.firewall.rules
sudo mv iptables.firewall.rules /etc/iptables.firewall.rules


# Apply the firewall rules (this will need to be done again later, but to get things running
sudo iptables-restore < /etc/iptables.firewall.rules


# This ensures it's run every time the system boots
sudo echo '#!/bin/sh' > /etc/network/if-pre-up.d/firewall
sudo echo '/sbin/iptables-restore < /etc/iptables.firewall.rules' >>  /etc/network/if-pre-up.d/firewall
sudo chmod +x /etc/network/if-pre-up.d/firewall

# Download and install ipset
sudo apt-get install ipset -y

# This is where we start blocking China
wget -P . https://raw.githubusercontent.com/bobbybrooks/firewall-stuff/master/block-china.sh
sudo mv block-china.sh /etc/
sudo chmod +x /etc/block-china.sh
# Now let's run it
/etc/block-china.sh

# remove the prefix for the china-rule from /etc/iptables.firewall.rules
sudo sed -i 's/#removeme //g' /etc/iptables.firewall.rules

# And reload the rules with the update
sudo iptables-restore < /etc/iptables.firewall.rules


#write out current crontab
sudo crontab -l > mycron1
cat mycron1 | grep -v 'etc/block-china.sh' >> mycron
#echo new cron into cron file
sudo echo "* 5 * * * /etc/block-china.sh" >> mycron
#install new cron file
sudo crontab mycron
sudo rm mycron*
echo
echo 'Setting cronjob to run /etc/block-china.sh at 5am every day'
echo 'with this line:'
echo '* 5 * * * /etc/block-china.sh'
echo
echo 'run "sudo crontab -e"'
echo 'to make changes'
echo
echo 'Here's the format'
echo '* * * * * "command to be executed"'
echo '- - - - -'
echo '| | | | |'
echo '| | | | ----- Day of week (0 - 7) (Sunday=0 or 7)'
echo '| | | ------- Month (1 - 12)'
echo '| | --------- Day of month (1 - 31)'
echo '| ----------- Hour (0 - 23)'
echo '------------- Minute (0 - 59)'
echo

