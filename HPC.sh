#!/bin/bash
 #while-menu:a menu-driven system information program
 #incicio
 #funções

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

 display_result() {
  dialog --title "$1" \
      --no-collapse \
      --msgbox "$result" 0 0
 }

carregar_menu(){
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
 menu_principal(){

   dialog --inputbox "Digite seu nome: " 0 0 2>/tmp/nome.txt
   nome=$( cat /tmp/nome.txt )
   result=$( cat /tmp/nome.txt )
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
		"2" "Ajuste o relógio do Sistema" \
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
		   carregar_menu
		   ;;
		2 ) 
		  dialog \
		--title "Ajuste o relogio" \
		--timebox "Use setas e TAB" \
		0 0 \
		23 59 30
		   ;;
 
   		3 )
		   display result "Selecione 1, 2 ou 3."
		   ;;
	esac
    done		
 }
 #fim das funções
menu_principal
