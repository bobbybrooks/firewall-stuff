#!/bin/bash

# remove any remnants of previous runs
rm /etc/cn.zone
ipset destroy china

# Create the ipset list
ipset -N china hash:net


# Pull the latest IP set for China
wget -P . http://www.ipdeny.com/ipblocks/data/countries/cn.zone
# Add my own stuff to block all of APNIC
#echo "110.0.0.0/8" >> cn.zone
#echo "111.0.0.0/8" >> cn.zone
#echo "112.0.0.0/8" >> cn.zone
#echo "113.0.0.0/8" >> cn.zone
#echo "114.0.0.0/8" >> cn.zone
#echo "115.0.0.0/8" >> cn.zone
#echo "116.0.0.0/8" >> cn.zone
#echo "117.0.0.0/8" >> cn.zone
#echo "118.0.0.0/8" >> cn.zone
#echo "119.0.0.0/8" >> cn.zone
#echo "120.0.0.0/8" >> cn.zone
#echo "121.0.0.0/8" >> cn.zone
#echo "122.0.0.0/8" >> cn.zone
#echo "123.0.0.0/8" >> cn.zone
#echo "124.0.0.0/8" >> cn.zone
#echo "125.0.0.0/8" >> cn.zone
#echo "126.0.0.0/8" >> cn.zone

sudo mv cn.zone /etc/cn.zone

# Add each IP address from the downloaded list into the ipset 'china'
for i in $(cat /etc/cn.zone ); do ipset -A china $i; done

