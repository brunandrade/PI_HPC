#!/bin/bash

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

 display_result() {
  dialog --title "$1" \
      --no-collapse \
      --msgbox "$result" 0 0
 }

menuInstalacao(){
while true; do
	exec 3>&1
	selection=$(dialog \
		--backtitle "opções do sistema" \
		--title "Menu" \
		--clear \
		--cancel-label "Voltar" \
		--menu "Selecione uma opção:" $HEIGHT $WIDTH 4 \
		"1" "instalar squid3" \
		"2" "instalar iptables" \
		"3" "instalar vim" \
		2>&1 1>&3)
	exit_status=$?
	exec 3>&-
	case $exit_status in
		$DIALOG_CANCEL)
		echo "MenuPrincipal."
		menu_principal
		exit
		;;
	$DIALOG_ESC)
		clear
		echo "programa abortado.">&2
		exit 1
		;;
	esac
	case $selection in
		0 )
		   clear
		   echo "programa encerrado"
		   ;;
		1 )
		   dialog --yesno 'Deseja instalar o SQUID3?' 0 0

		   if [ $? = 0 ]; then
        		if ! apt-get install squid3
			display_result "squid3 instalado"
			clear
		   then
		   	clear  
	         fi
		   else
        		display_result "squid3 não instalado"
		   fi
		   ;;
		2 ) 
		   dialog --yesno 'Deseja instalar o IPTABLES?' 0 0

		   if [ $? = 0 ]; then
        		if ! apt-get install iptables
			display_result "iptables instalado"
			clear
		   then
		   	clear  
	         fi
		   else
        		display_result "squid3 não instalado"
		   fi
		   ;;
		3 ) 
		  dialog --yesno 'Deseja instalar o VIM?' 0 0

		   if [ $? = 0 ]; then
        		if ! apt-get install vim
			display_result "vim instalado"
			clear
		   then
		   	clear  
	         fi
		   else
        		display_result "squid3 não instalado"
		   fi
		   ;;  
   		4 )
		   display result "Selecione 1, 2 ou 3."
		   ;;
	esac
    done			
 }
 MenuDadosdoSistema(){
while true; do
	exec 3>&1
	selection=$(dialog \
		--backtitle "Sistema" \
		--title "Informações do sistema" \
		--clear \
		--cancel-label "Voltar" \
		--menu "Selecione uma opção:" $HEIGHT $WIDTH 4 \
		"1" "Processador" \
		"2" "Memória" \
		"3" "HD" \
		"4" " Barramentos" \
		2>&1 1>&3)
	exit_status=$?
	exec 3>&-
	case $exit_status in
		$DIALOG_CANCEL)
		echo "MenuPrincipal."
		menu_principal
		exit
		;;
	$DIALOG_ESC)
		clear
		echo "programa abortado.">&2
		exit 1
		;;
	esac
	case $selection in
		0)
		   clear
		   echo "programa encerrado"
		   ;;
		1)
                    rm systeminfo.txt -r
		            echo -e "info CPU:"  >> systeminfo.txt
                    echo `cat /proc/cpuinfo | grep vendor | uniq` >> systeminfo.txt
                    echo `cat /proc/cpuinfo | grep 'model name' | uniq` >> systeminfo.txt
                    echo `cat /proc/cpuinfo | grep 'MHz' | uniq`  >> systeminfo.txt
                    echo `cat /proc/cpuinfo | grep 'cache size' | sort | uniq` >> systeminfo.txt
                    echo "Cores : "`egrep "^processor" /proc/cpuinfo | wc -l` >> systeminfo.txt
                    echo `dmidecode -t4 | grep 'Core Count'` >> systeminfo.txt
                    dialog --title 'Informações da CPU' --textbox systeminfo.txt 0 0
          
            ;;    
		2) 
            rm systeminfo.txt -r
		    echo `cat /proc/meminfo | grep -i 'memTotal'` >> systeminfo.txt
			echo `cat /proc/meminfo | grep -i 'memFree'` >> systeminfo.txt
			echo `cat /proc/meminfo | grep -i 'memAvailable'` >> systeminfo.txt
            echo `dmidecode --type 17 | grep 'MHz' | grep 'Configured Clock Speed' | uniq` >> systeminfo.txt
            dialog --title 'Informações da Memória' --textbox systeminfo.txt 0 0
						
          ;;
		3) 
          rm systeminfo.txt -r
		  echo `fdisk -l` >> systeminfo.txt
          dialog --title 'Informações do HD' --textbox systeminfo.txt 0 0
          ;;
   		4)
          rm systeminfo.txt -r
		  echo `lsusb` >> systeminfo.txt
		  echo `lsmod` >> systeminfo.txt
		  echo `lspci -v | m` >> systeminfo.txt
          dialog --title 'Informações dos Barramentos' --textbox systeminfo.txt 0 0
		   ;;
	esac
    done	

 }
 menu_principal(){

   display_result "Bem Vindo"
   
   while true; do
	exec 3>&1
	selection=$(dialog \
		--backtitle "opções do sistema" \
		--title "Menu" \
		--clear \
		--cancel-label "Sair" \
		--menu "Selecione uma opção:" $HEIGHT $WIDTH 4 \
		"1" "instalar programas" \
		"2" "Dados do Sistema" \
		2>&1 1>&3)
	exit_status=$?
	exec 3>&-
	case $exit_status in
		$DIALOG_CANCEL)
		clear
		echo "programa encerrado."
		exit
		;;
	$DIALOG_ESC)
		clear
		echo "programa abortado.">&2
		exit 1
		;;
	esac
	case $selection in
		0 )
		   clear
		   echo "programa encerrado"
		   ;;
		1 )
		  menuInstalacao
		   ;;
		2 ) 
		  MenuDadosdoSistema
		  	 ;;
 
   		3 )
		   display result "Selecione 1, 2 ou 3."
		   ;;
	esac
    done		
 }
 #fim das funções
menu_principal
