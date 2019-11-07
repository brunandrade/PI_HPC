#!/bin/bash
#  firewall script com iptables
#
#  Copyright 2015 T4K3D0WN <takedown@outlook.com.br>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#
#



modprobe ip_tables


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



function AtivaPing(){
 echo -n "Ativando resposta do ping ................................. "
 echo "0" > /proc/sys/net/ipv4/icmp_echo_ignore_all
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

function limpatabelas(){
echo -n "Limpando regras ........................................... "
# limpando tabelas
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
}

function ativaprotecao(){
echo -n "Ativando protecao ......................................... "
# Ativando algumas coisas básicas do kernel
echo 1 > /proc/sys/net/ipv4/tcp_syncookies                     # Abilitar o uso de syncookies (muito útil para evitar SYN flood attacks)
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all               # desabilita o "ping" (Mensagens ICMP) para sua máquina
echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects          # Não aceite redirecionar pacotes ICMP
echo 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses  # Ative a proteção contra respostas a mensagens de erro falsas
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts        # Evita a peste do Smurf Attack e alguns outros de redes locais
}
function politicaspadrao(){
echo -n "Configurando padrao ....................................... "
# Configurando as políticas padrões
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Loga/Adiciona/Descarta hosts da lista "SUSPEITO" (cuja conexão não cumpre nenhuma das regras acima) {deixe como última regra!}
iptables -A INPUT -p tcp --dport=20 -j LOG --log-level warning --log-prefix "[firewall] [ftp]"
iptables -A INPUT -p udp --dport=20 -j LOG --log-level warning --log-prefix "[firewall] [ftp]"
iptables -A INPUT -p tcp --dport=21 -j LOG --log-level warning --log-prefix "[firewall] [ftp]"
iptables -A INPUT -p udp --dport=21 -j LOG --log-level warning --log-prefix "[firewall] [ftp]"
iptables -A INPUT -p tcp --dport=22 -j LOG --log-level warning --log-prefix "[firewall] [ssh]"
iptables -A INPUT -p udp --dport=22 -j LOG --log-level warning --log-prefix "[firewall] [ssh]"
iptables -A INPUT -p tcp --dport=23 -j LOG --log-level warning --log-prefix "[firewall] [telnet]"
iptables -A INPUT -p udp --dport=23 -j LOG --log-level warning --log-prefix "[firewall] [telnet]"
iptables -A INPUT -p icmp  -j LOG --log-level warning --log-prefix "[firewall] [ping]"
}

function permitirloop(){
echo -n "Permitindo loopback ....................................... "
# Permitindo loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permite o estabelecimento de novas conexões iniciadas por você // coração do firewall //
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED,NEW -j ACCEPT
}
function dns(){
echo -n "Ativando dns .............................................. "
# Libera o acesso do DNS (troque pelo seu, caso não use o DNS do google. Caso não saiba exclua a opção -s apagando até antes do -j)
iptables -A INPUT -p udp --sport 53  -j ACCEPT
iptables -A INPUT -p udp --sport 53  -j ACCEPT

# Liberando portas de serviços externos (descomente e altere conforme sua necessidade)
#iptables -A INPUT -p tcp -m multiport --dport 21,22,53,80,443,3128,8080 -j ACCEPT

#--- Criando listas de bloqueios

# Descarta pacotes reincidentes/persistentes da lista SUSPEITO (caso tenha 5 entradas ficará 1H em DROP / caso tenha 10 ficará 24H em DROP)
iptables -A INPUT -m recent --update --hitcount 10 --name SUSPEITO --seconds 86400 -j DROP
iptables -A INPUT -m recent --update --hitcount 5 --name SUSPEITO --seconds 3600 -j DROP

# Descarta pacotes reincidentes/persistentes da lista SYN-DROP (caso tenha 5 entradas ficará 1H em DROP / caso tenha 10 ficará 24H em DROP)
iptables -A INPUT -m recent --update --hitcount 10 --name SYN-DROP --seconds 86400 -j DROP
iptables -A INPUT -m recent --update --hitcount 5 --name SYN-DROP --seconds 3600 -j DROP
}
function criachain(){
echo -n "criando chains ............................................ "
# Cria a CHAIN "SYN"
iptables -N SYN
iptables -A SYN -m limit --limit 10/min --limit-burst 3 -j LOG --log-level warning --log-prefix "[firewall] [SYN: DROP]"
iptables -A SYN -m limit --limit 10/min --limit-burst 3 -m recent --set --name SYN-DROP -j DROP
iptables -A SYN -m limit --limit 1/min --limit-burst 1 -j LOG --log-level warning --log-prefix "[firewall] [SYN: FLOOD!]"
iptables -A SYN -j DROP

# Cria a CHAIN "SCANNER"
iptables -N SCANNER
iptables -A SCANNER -m limit --limit 10/min --limit-burst 3 -j LOG --log-level warning --log-prefix "[firewall] [SCANNER: DROP]"
iptables -A SCANNER -m limit --limit 10/min --limit-burst 3 -m recent --set --name SUSPEITO -j DROP
iptables -A SCANNER -m limit --limit 1/min --limit-burst 1 -j LOG --log-level warning --log-prefix "[firewall] [SCANNER: FLOOD!]"
iptables -A SCANNER -j DROP

#--- Bloqueios

# Rejeita os restos de pacotes após fechar o torrent (subistitua 12300 pela porta do seu torrent)
iptables -A INPUT -p tcp --dport 12300 -j REJECT
iptables -A INPUT -p udp --dport 12300 -j DROP

# Manda os pacotes SYN suspeitos (não liberados acima) para a chain "SYN"
iptables -A INPUT -p tcp --syn -m state --state NEW -j SYN

# Adicionando regras para CHAIN "SCANNER"
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL ACK -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL SYN,ACK -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL FIN,PSH,URG -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL PSH,URG,FIN -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL URG,PSH,FIN -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL FIN,SYN -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j SCANNER
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j SCANNER
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL FIN -j SCANNER

# Descarta pacotes inválidos
iptables -A INPUT -m state --state INVALID -j DROP

#bloqueia portas


iptables -A INPUT -p tcp --dport=20 -j DROP
iptables -A INPUT -p udp --dport=20 -j DROP
iptables -A INPUT -p tcp --dport=21 -j DROP
iptables -A INPUT -p udp --dport=21 -j DROP
iptables -A INPUT -p tcp --dport=22 -j DROP
iptables -A INPUT -p udp --dport=22 -j DROP
iptables -A INPUT -p tcp --dport=23 -j DROP
iptables -A INPUT -p udp --dport=23 -j DROP
iptables -A INPUT -m recent --update --name SUSPEITO -m limit --limit 10/min --limit-burst 3 -j LOG --log-level warning --log-prefix "[firewall] [suspeito]"
iptables -A INPUT -m limit --limit 10/min --limit-burst 3 -m recent --set --name SUSPEITO -j DROP
iptables -A INPUT -j DROP
}

function IniciaFirewall(){

echo -e "\033[01;31m===================================================================="
echo -e "|     \033[01;32mF1R3W4LL\033[01;31m          ______         \033[01;32mCR34T3D  BY:\033[01;31m                |"
echo "|                    .-.      .-.                                  |"
echo "|                   /            \                                 |"
echo -e "|                  | [\033[01;32m T4K3D0WN \033[01;31m] |                                |"
echo "|                  |,  .-.  .-.  ,|                                |"
echo "|                  | )(|_/  \|_)( |                                |"
echo "|                  |/     /\     \|                                |"
echo "|          _       (_     ^^     _)                                |"
echo "|  _\ ____) \_______\__|IIIIII|__/_______________________________  |"
echo "| (_)[___]{}<________|-\IIIIII/-|________________________________/ |"
echo "|   /     )_/        \          /                                  |"
echo "|                     \ ______ /                                   |"
echo -e "====================================================================\033[01;37m"
echo

 if limpatabelas
  then
   echo -e "[\033[01;32m  OK  \033[01;37m] "
  else
   echo -e "[\033[01;31m  Erro  \033[01;37m]"
 fi
 if ativaprotecao
  then
   echo -e "[\033[01;32m  OK  \033[01;37m]"
  else
   echo -e "[\033[01;31m  Erro  \033[01;37m]"
 fi
 if politicaspadrao
  then
   echo -e "[\033[01;32m  OK  \033[01;37m]"
  else
   echo -e "[\033[01;31m  Erro  \033[01;37m]"
 fi
 if permitirloop
  then
   echo -e "[\033[01;32m  OK  \033[01;37m]"
  else
   echo -e "[\033[01;31m  Erro  \033[01;37m]"
 fi
 if dns
  then
   echo -e "[\033[01;32m  OK  \033[01;37m]"
  else
   echo -e "[\033[01;31m  Erro  \033[01;37m]"
 fi
 if criachain
  then
   echo -e "[\033[01;32m  OK  \033[01;37m]"
  else
   echo -e "[\033[01;31m  Erro  \033[01;37m]"
 fi

echo -n "iniciando firewall ........................................ "
echo -e  -n "[\033[01;32m  OK  \033[01;37m]"
echo










}

function ParaFirewall(){
echo -e "\033[01;31m===================================================================="
echo -e "|     \033[01;32mF1R3W4LL\033[01;31m          ______         \033[01;32mCR34T3D  BY:\033[01;31m                |"
echo "|                    .-.      .-.                                  |"
echo "|                   /            \                                 |"
echo -e "|                  | [\033[01;32m T4K3D0WN \033[01;31m] |                                |"
echo "|                  |,  .-.  .-.  ,|                                |"
echo "|                  | )(|_/  \|_)( |                                |"
echo "|                  |/     /\     \|                                |"
echo "|          _       (_     ^^     _)                                |"
echo "|  _\ ____) \_______\__|IIIIII|__/_______________________________  |"
echo "| (_)[___]{}<________|-\IIIIII/-|________________________________/ |"
echo "|   /     )_/        \          /                                  |"
echo "|                     \ ______ /                                   |"
echo -e "====================================================================\033[01;37m"
echo
 if LimpaRegras
  then
   echo -e "[\033[01;32m  OK  \033[01;37m] "
  else
   echo -e "[\033[01;31m  Erro  \033[01;37m]"
 fi
 if AtivaPing
  then
   echo -e "[\033[01;32m  OK  \033[01;37m]"
  else
   echo -e "[\033[01;31m  Erro  \033[01;37m]"
 fi
 if DesativaProtecao
  then
   echo -e "[\033[01;32m  OK  \033[01;37m]"
  else
   echo -e "[\033[01;31m  Erro  \033[01;37m]"
 fi
 # Lista de Funções executadas
 #LimpaRegras
 #AtivaPing
 #DesativaProtecao
 echo
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