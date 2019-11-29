#!/bin/bash

function IniciaFirewall(){
# Bloc everything by default
sudo iptables -t filter -P INPUT DROP
sudo iptables -t filter -P FORWARD DROP
sudo iptables -t filter -P OUTPUT DROP

# Authorize already established connexions
sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -t filter -A INPUT -i lo -j ACCEPT
sudo iptables -t filter -A OUTPUT -o lo -j ACCEPT

# ICMP (Ping)
sudo iptables -t filter -A INPUT -p icmp -j ACCEPT
sudo iptables -t filter -A OUTPUT -p icmp -j ACCEPT

# SSH
sudo iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT

# DNS
sudo iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
sudo iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
sudo iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
sudo iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT

# HTTP
sudo iptables -t filter -A OUTPUT -p tcp --dport 80 -j DROP
sudo iptables -t filter -A INPUT -p tcp --dport 80 -j DROP

#HTTPS
sudo iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT

# FTP
sudo iptables -t filter -A OUTPUT -p tcp --dport 20:21 -j ACCEPT
sudo iptables -t filter -A INPUT -p tcp --dport 20:21 -j ACCEPT

# Git
sudo iptables -t filter -A OUTPUT -p tcp --dport 9418 -j ACCEPT
sudo iptables -t filter -A INPUT -p tcp --dport 9418 -j ACCEPT




}

function ParaFirewall(){
# Empty all rules
DesativaProtecao
LimpaRegras
}
function LimpaRegras(){
echo -n "Limpando regras ........................................... "
 # Limpando as Chains
 iptables -F INPUT
 iptables -F OUTPUT
 iptables -F FORWARD
 iptables -F -t filter
 iptables -F POSTROUTING -t nat
 iptables -F PREROUTING -t nat
 iptables -F OUTPUT -t nat
 iptables -F -t nat
 iptables -t nat -F
 iptables -t mangle -F
 iptables -X
 # Zerando contadores
 iptables -Z
 iptables -t nat -Z
 iptables -t mangle -Z
 # Define politicas padrao ACCEPT
 iptables -P INPUT ACCEPT
 iptables -P OUTPUT ACCEPT
 iptables -P FORWARD ACCEPT
}


function DesativaProtecao(){
 echo -n "Removendo regras de proteção .............................. "
 i=/proc/sys/net/ipv4
 echo "1" > /proc/sys/net/ipv4/ip_forward
 echo "0" > $i/tcp_syncookies
 echo "0" > $i/icmp_echo_ignore_broadcasts
 echo "0" > $i/icmp_ignore_bogus_error_responses
 for i in /proc/sys/net/ipv4/conf/*; do
   echo "1" > $i/accept_redirects
   echo "1" > $i/accept_source_route
   echo "0" > $i/log_martians
   echo "0" > $i/rp_filter
 done
}


case $1 in
  start)
   IniciaFirewall
   exit 0
  ;;

  stop)
   ParaFirewall
  ;;



  *)
   echo "Escolha uma opção válida { start | stop }"
   echo
esac