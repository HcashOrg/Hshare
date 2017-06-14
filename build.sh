#!/bin/bash

set -e

date
ps axjf

#################################################################
# Update Ubuntu and install prerequisites for running HShare   #
#################################################################
sudo apt-get update
#################################################################
# Build HShare from source                                     #
#################################################################
NPROC=$(nproc)
echo "nproc: $NPROC"
#################################################################
# Install all necessary packages for building HShare           #
#################################################################
sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

cd /usr/local
file=/usr/local/hshareX
if [ ! -e "$file" ]
then
        sudo git clone https://github.com/hshareproject/hshareX.git
fi

cd /usr/local/hshareX/src
file=/usr/local/hshareX/src/hshared
if [ ! -e "$file" ]
then
        sudo make -j$NPROC -f makefile.unix
fi

sudo cp /usr/local/hshareX/src/hshared /usr/bin/hshared

################################################################
# Configure to auto start at boot                                      #
################################################################
file=$HOME/.hshare
if [ ! -e "$file" ]
then
        sudo mkdir $HOME/.hshare
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | sudo tee $HOME/.hshare/hshare.conf
file=/etc/init.d/hshare
if [ ! -e "$file" ]
then
        printf '%s\n%s\n' '#!/bin/sh' 'sudo hshared' | sudo tee /etc/init.d/hshare
        sudo chmod +x /etc/init.d/hshare
        sudo update-rc.d hshare defaults
fi

/usr/bin/hshared
echo "HShare has been setup successfully and is running..."
exit 0

