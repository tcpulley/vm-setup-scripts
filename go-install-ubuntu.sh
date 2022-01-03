#! /usr/bin/env bash

# Fail on first error
set -e

#
echo -e "Configuring Install Environment Variables.."
GOLANG_VERSION=$(curl https://go.dev/VERSION?m=text)
GOLANG_TARBALL="$GOLANG_VERSION.linux-amd64.tar.gz"
GOLANG_TEMP_FILE="/tmp/$GOLANG_TARBALL"
GOLANG_INSTALL_ROOT_DIR="/usr/local"
GOLANG_INSTALL_DIR="$GOLANG_INSTALL_ROOT_DIR/go"


echo -e "\nInstalling GO Lang version $GOLANG_VERSION..."

echo -e "\nDownloading GO Lang Archive..."
curl https://dl.google.com/go/$GOLANG_TARBALL -o $GOLANG_TEMP_FILE
#dl.google.com/go/$GOLANG_TARBALL
#https://dl.google.com/go/go1.17.5.linux-amd64.tar.gz

if [ -d $GOLANG_INSTALL_DIR ]
then
   echo -e "\nDeleting Existing GO Lang Installation"
   sudo rm -fr $GOLAND_INSTALL_DIR
fi

sudo tar -C $GOLANG_INSTALL_ROOT_DIR -xzf $GOLANG_TEMP_FILE

# Add GO to the path
echo -e "\nAdding GO Lang execs to $GOLANG_ROOT_DIR/bin ..."

for GoExecutable in $GOLANG_INSTALL_DIR/bin/*
do
   echo -e "\nCreating Symbolic link for $GoExecutable"
   sudo ln -s $GoExecutable $GOLANG_INSTALL_ROOT_DIR/bin/
done
