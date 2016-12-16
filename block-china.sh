# Create the ipset list
ipset -N china hash:net

# remove any old list that might exist from previous runs of this script
rm cn.zone

# Pull the latest IP set for China
wget -P . http://www.ipdeny.com/ipblocks/data/countries/cn.zone
# Add my own stuff
echo "116.0.0.0/8" >> cn.zone
sudo mv cn.zone /etc/cn.zone

# Add each IP address from the downloaded list into the ipset 'china'
for i in $(cat /etc/cn.zone ); do ipset -A china $i; done

# Restore iptables
/sbin/iptables-restore < /etc/iptables.firewall.rules
