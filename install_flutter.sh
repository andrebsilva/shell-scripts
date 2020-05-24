#!/bin/bash

# INSTALL FLUTTER
sudo apt install bash curl git unzip xz-utils zip libglu1-mesa libcanberra-gtk-module 
mkdir ~/DevTools
tar xvf ~/Downloads/flutter_linux_*.**.*-stable.tar.xz -C ~/DevTools/
sudo nano ~/.bashrc
  FLUTTER_HOME=/home/$USER/DevTools/flutter
  PATH=$FLUTTER_HOME/bin:$PATH
source ~/.basrc
flutter --version

# INSTALL ANDROID_STUDIO
sudo apt install openjdk-8-jre-headless
java -version