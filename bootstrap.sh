#!/bin/bash

## ##############################################################################################
## UBUNTU 18.04 CONFIGURATION SCRIPT                                                            #
## -------------------------------------------------------------------------------------------- #
## UNIVERSIDADE FEDERAL DO TOCANTINS [UFT] (Federal University of Tocantins)                    #                                                              #
## Palmas, TOCANTINS - BRAZIL                                                                   #
## André Barcelos Silva [barcelos@uft.edu.br]                                                   #
## github.com/andrebsilva                                                                       #
## -------------------------------------------------------------------------------------------- #
## FIRST SEVEN STEPS:                                                                           #
## 1) Clone this git repository                                                                 #
##	$ git clone https://github.com/andrebsilva/shell-scripts.git                            #
## 2) Access BOOTSTRAP directory                                                                #
##	$ cd shell-scripts                                                                      #
## 3) Create directory for deb packages, and set DIRTOOLS var bellow                            #
##	$ mkdir toolstoinstall                                                                  #
## 4) Move all deb packages downloaded to that directory                                        #
##	$ mv ~/Downloads/*.deb toolstoinstall/                                                  #
## 5) Create directory for deb packages already installed, and set DIRINSTALLED variable bellow #
##	$ mkdir installedtools                                                                  #
## 6) Add execution permission to the shell script file                                         #
##	$ chmod +x bootstrap.sh                                                                 #
## 7) Execute shell script file with parameter: password of the sudo                            #
##	$ ./bootstrap.sh p@ssw0rd                                                               #
## ##############################################################################################

## SUDO PASSWORD (#1 Parameter)
SUDOPASS=$1

## DIRECTORY FOR DEB PACKAGES, TO INSTALL IT
DIRTOOLS="toolstoinstall/"

## DIRECTORY FOR DEB PACKAGES ALREADY INSTALLED
DIRINSTALLED="installedtools/"

## DIALOG LINUX DISTRIBUTION NAME
LDNAME="UBUNTU MATE"

## DIALOG MATE TITLE
UMTITLE="$LDNAME 18.04 LTS"

## DIALOG TITLE
DLTITLE="$UMTITLE | UFT | "

## DIALOG HEIGHT
DLH=18

## DIALOG WIDTH
DLW=96

## Load superuser password for the Terminal session
echo "$SUDOPASS" | sudo -S clear

## Install DIALOG package if not installed
dlpkg="dialog"
check=$(dpkg -s "$dlpkg" | grep installed)
if [ "" == "$check" ]; then
	sudo apt update
	sudo apt install "$dlpkg" -y
else
	dialog --title "$DLTITLE" --msgbox "\n\n$dlpkg package already installed." $DLH $DLW
fi

## Operation System update, upgrade, clean and restart
question_update="\n\nDo you want to UPDATE the $UMTITLE package repository?\n\n# apt update"
question_upgrade="\n\nDo you want to UPGRADE $UMTITLE packages?\n\n# apt full-upgrade -y"
dialog --stdout --title "$DLTITLE UPDATE REPOSITORY" --yesno "$question_update" $DLH $DLW
if [ "$?" -eq 0 ]; then
	clear
	sudo apt update
	dialog --stdout --title "$DLTITLE UPGRADE PACKAGES" --yesno "$question_upgrade" $DLH $DLW
	if [ "$?" -eq 0 ]; then
		clear
		sudo apt full-upgrade -y
		sudo apt autoremove
		sudo apt autoclean
	fi
	optionrh=$(dialog --stdout --title "$DLTITLE" --menu "" $DLH $DLW 2 1 "Reboot the Computer" 2 "Turn off the Computer")
	if [ "$?" -eq 0 ]; then
		case "$optionrh" in
			1) sudo reboot ;;
			2) sudo shutdown -h now ;;
		esac
	fi
fi

## Installing packages and its dependencies available on the Ubuntu official repository
packages_list=(
atril
caffeine
calibre
codeblocks
curl
font-manager
gedit
git
libavcodec-extra
neofetch
openjdk-11-jdk
ubuntu-restricted-extras
vim
vlc
)
sudo apt update
for opl in "${packages_list[@]}";
do
	checking_install=$(dpkg -s "$opl" | grep installed)
	if [ "" == "$checking_install" ]; then
		question_install="\n\nDo you want to install the $pol package in the $UMTITLE?\n\n# apt install $opl -y"
		dialog --stdout --title "$DLTITLE INSTALL PACKAGES" --yesno "$question_install" $DLH $DLW
		if [ "$?" -eq 0 ]; then
			sudo apt install "$opl" -y
			clear
		fi
	fi
done

## Installing DEB packages previously downloaded 
options=$(find $DIRTOOLS -mindepth 1 -maxdepth 1 -type f -not -name '.deb' -printf "%f %Td-%Tm-%TY off\n");
packages=$(dialog --checklist "Select packages to install: " 24 84 18  $options --output-fd 1);
for p in $packages
do
	sudo dpkg -i "$DIRTOOLS$p"
	mv "$DIRTOOLS$p" "$DIRINSTALLED"
done

dialog --title "$DLTITLE" --msgbox "\n\nI hope everything went well.\n\nAny question, information and suggestion, please contact us:\n\n\nBARCELOS, André\nbarcelos@uft.edu.br\n\nThank you!" $DLH $DLW

clear

## END
