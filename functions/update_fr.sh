#!/bin/bash
function update {
CONF="/etc/svxlink/svxlink.conf"
GPIO="/etc/svxlink/gpio.conf"
OP=/etc/svxlink

whiptail --title "Mis à jour" --msgbox "Mis à jour les répositoires pour nodejs et l'éxpansion pou l'avenire. Tapé OK pour continuer" 8 78

	echo -e "$(date)" "${YELLOW}  #### updates and upgrades #### ${NORMAL}" | tee -a  /var/log/install.log

 	sudo apt-get update
 	
 	sudo apt update
 	sudo apt upgrade -y
	VERSIONS=svxlink/src/versions | tee -a   /var/log/install.log   

	echo -e "$(date)" "${YELLOW}  #### commence build #### ${NORMAL}" | tee -a  /var/log/install.log
###### BUILD ESSENTIALS ####
whiptail --title "Build Essentials" --msgbox "Addition tous les paquets necessaires pour Svxlink. Tapé OK pour continuer" 8 78

	echo -e "$(date)" "${YELLOW} ### Installation des paquets ### ${NORMAL}" | tee -a  /var/log/install.log
 	sudo apt install build-essential g++ make cmake libsigc++-2.0-dev php8.2 nodejs libgsm1-dev libudev-dev libpopt-dev tcl-dev libgpiod-dev gpiod libgcrypt20-dev libspeex-dev libasound2-dev alsa-utils libjsoncpp-dev libopus-dev rtl-sdr libcurl4-openssl-dev libogg-dev librtlsdr-dev groff doxygen graphviz python3-serial sqlite3 php8.2-sqlite3 toilet -y

}