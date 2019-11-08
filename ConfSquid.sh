#!/bin/bash
echo "INSTALAÇÂO AUTOMATICA SERVIDOR PROXY"
#echo "EXECUTAR SCRIPT[S/n]"
#read sim
#test "$sim" = "n" && exit
apt-get install squid -y
mv /etc/squid/squid.conf /etc/squid/squid.conf.orig
touch /etc/squid/squid.conf
echo "#Porta do squid" >> /etc/squid/squid.conf
echo "http_port 3128 transparent" >> /etc/squid/squid.conf
echo "#Nome da maquina" >> /etc/squid/squid.conf
echo "visible_hostname debian" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "#Nega cache paginas dinamicas" >> /etc/squid/squid.conf
echo "acl QUERY urlpath_regex cgi-bin \?" >> /etc/squid/squid.conf
echo "no_cache deny QUERY" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "#Memoria usada para cache de paginas" >> /etc/squid/squid.conf
echo "cache_mem 128 MB" >> /etc/squid/squid.conf
echo "#Tamanho maximo arquivo salvo em cache" >> /etc/squid/squid.conf
echo "maximum_object_size 100 MB" >> /etc/squid/squid.conf
echo "#Tamanho minino arquivo salvo em cache" >> /etc/squid/squid.conf
echo "minimum_object_size 2 KB" >> /etc/squid/squid.conf
echo "#Apaga arquivos antigos atingindo 95% HD ate voltar abaixo de 90%" >> /etc/squid/squid.conf
echo "cache_swap_low 90" >> /etc/squid/squid.conf
echo "cache_swap_high 95" >> /etc/squid/squid.conf
echo "#Local e tamanho reservado ao cache" >> /etc/squid/squid.conf
echo "cache_dir ufs /var/spool/squid 2048 16 256" >> /etc/squid/squid.conf
echo "#Registros de acessos" >> /etc/squid/squid.conf
echo "cache_access_log /var/log/squid/access.log" >> /etc/squid/squid.conf
echo "#Tradução do squid no browser" >> /etc/squid/squid.conf
echo "error_directory /usr/share/squid/errors/Portuguese" >> /etc/squid/squid.conf
echo "#Atualização de cache de 15ms a cada acesso e de 2 em 2 dias" >> /etc/squid/squid.conf
echo "refresh_pattern ^ftp: 15 20% 2280" >> /etc/squid/squid.conf
echo "refresh_pattern ^gopher: 15 0% 2280" >> /etc/squid/squid.conf
echo "refresh_pattern . 15 20% 2280" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "acl all src 0.0.0.0/0.0.0.0" >> /etc/squid/squid.conf
echo "acl manager proto cache_object" >> /etc/squid/squid.conf
echo "acl localhost src 127.0.0.1/255.255.255.255" >> /etc/squid/squid.conf
echo "acl SSL_ports port 443 563" >> /etc/squid/squid.conf
echo "#Restringir as portas de saída do servidor proxy" >> /etc/squid/squid.conf
echo "acl Safe_ports port 21 80 433 563 70 210 280 488 59 777 901 1025-65535" >> /etc/squid/squid.conf
echo "acl purge method PURGE" >> /etc/squid/squid.conf
echo "acl CONNECT method CONNECT" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "http_access allow manager localhost" >> /etc/squid/squid.conf
echo "http_access deny manager" >> /etc/squid/squid.conf
echo "http_access allow purge localhost" >> /etc/squid/squid.conf
echo "http_access deny purge" >> /etc/squid/squid.conf
echo "http_access deny !Safe_ports" >> /etc/squid/squid.conf
echo "http_access deny CONNECT !SSL_ports" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "#Livrando regras para chefe" >> /etc/squid/squid.conf
echo "#acl chefe src 192.168.2.2" >> /etc/squid/squid.conf
echo "#http_access allow chefe" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "#Bloqueio por dominios (Os digitados no browser)" >> /etc/squid/squid.conf
echo "#acl bloqueados dstdomain www.orkut.com.br www.uol.com.br www.terra.com.br" >> /etc/squid/squid.conf
echo "#http_access deny bloqueados" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "#Desbloquendo dominio no horario almoço" >> /etc/squid/squid.conf
echo "#acl almoço time 14:00-14:0" >> /etc/squid/squid.conf
echo "#acl uol dstdomain www.uol.com.br uol.com uol.com.br" >> /etc/squid/squid.conf
echo "#http_access allow uol almoço" >> /etc/squid/squid.conf
echo "#http_access deny uol" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "#Bloqueio por horario" >> /etc/squid/squid.conf
echo "#acl almoço time 13:35-13:40" >> /etc/squid/squid.conf
echo "#http_access allow  almoço " >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "#Bloqueio de dominios usando arquivo de texto" >> /etc/squid/squid.conf
echo "#acl bloqueados url_regex -i "/etc/squid/dominio.block" " >> /etc/squid/squid.conf
echo "#http_access deny bloqueados" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "#Permitindo somente dominios especificos" >> /etc/squid/squid.conf
echo "#acl permitidos url_regex -i "/etc/squid/dominio.allow" " >> /etc/squid/squid.conf
echo "#http_access allow permitidos" >> /etc/squid/squid.conf
echo "#http_access deny all" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "#Bloqueando dominios por ips" >> /etc/squid/squid.conf
echo "#acl ips-bloqueados dst 200.234.21.23 200.212.15.45" >> /etc/squid/squid.conf
echo "#http_access deny ips-bloqueados" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "#Bloqueando palavras nas urls (tudo digitado)" >> /etc/squid/squid.conf
echo "#acl palavrasblock dstdom_regex "/etc/squid/palavras.block" " >> /etc/squid/squid.conf
echo "#http_access deny palavrasblock" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "#Bloqueando arquivos extesão " >> /etc/squid/squid.conf
echo "#acl extensão url_regex -i .exe .mp3" >> /etc/squid/squid.conf
echo "#http_access deny extensão" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "#Bloquendo imagens" >> /etc/squid/squid.conf
echo "#acl imagem urlpath_regex -i "/etc/squid/ext" " >> /etc/squid/squid.conf
echo "#http_access deny imagem" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "#Controle de banda(calculo feito em bytes 1M=131.072)" >> /etc/squid/squid.conf
echo "#Dividindo o valor em kbits por 8 e multiplicando por 1024" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "acl redelocal src 192.168.2.0/24" >> /etc/squid/squid.conf
echo "#delay_pools 1" >> /etc/squid/squid.conf
echo "#delay_class 1 2" >> /etc/squid/squid.conf
echo "#delay_parameters 1 114688/114688 131072/131072" >> /etc/squid/squid.conf
echo "#delay_access 1 allow redelocal" >> /etc/squid/squid.conf
echo >> /etc/squid/squid.conf
echo "http_access allow localhost" >> /etc/squid/squid.conf
echo "http_access allow redelocal" >> /etc/squid/squid.conf
echo "http_access deny all" >> /etc/squid/squid.conf

/etc/init.d/squid restart