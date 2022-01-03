#!/usr/bin/env bash

if (($EUID != 0)); then
   echo "This script requires root privileges"
   exit -1
fi

apt-get update	
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
	
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

# What Ubuntu release is this - Need to specify in apt sources
UBUNTU_RELEASE=$(cat /etc/os-release | grep UBUNTU_CODENAME | cut -d = -f 2)

if [ "$UBUNTU_RELEASE" == "eoan" ]; then
   UBUNTU_RELEASE=disco
fi

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_RELEASE stable"
apt-get update
apt-get install docker-ce
apt clean

# Add the current user to the docker group
usermod -G docker -a $SUDO_USER

# Inform the user they need to take action to have access to the docker group Run newgrp so the user doesn't have to log out/in or reboot if running Ubuntu
echo -e  "\n*** INFO ***\n\
You have been added to the newly created group:\e[1m docker\e[0m \n\
You can gain access to the group by logging out/in \n\
or by running the following command:\e[1m newgrp docker \e[0m"

