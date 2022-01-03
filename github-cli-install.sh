#!/usr/bin/env bash


set -e


if ! command -v curl &> /dev/null
then
   echo -e "\nCurl command not found"
   echo -e "\nInstalling curl..."

   sudo apt-get install curl
fi

echo -e "\nAdding GitHub CLI package info..."

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

echo -e "\nUpdating Pack Info..."
sudo apt update

echo -e "\nInstalling GitHub CLI..."
sudo apt install gh

