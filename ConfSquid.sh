#!/bin/bash
cp /etc/squid/squid.conf /etc/squid/squid_old.conf
cp  ArquivoSquidFuncional.conf /etc/squid/squid.conf
cp  bad-sites.acl  /etc/squid/bad-sites.acl 
apt-get install apache2-utils
sudo htpasswd -c -d /etc/squid/passwords master
sudo chmod o+r /etc/squid/passwords
/etc/init.d/squid restart
squid -k reconfigure