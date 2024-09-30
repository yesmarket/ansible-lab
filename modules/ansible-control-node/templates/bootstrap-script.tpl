#!/bin/bash
sudo apt-get update
sudo apt -y install python3-pip
pip3 install ansible --no-warn-script-location
export PATH=~/.local/bin:$PATH
echo ${ssh_public_key} >> ~/.ssh/id_rsa.pub
base64 -d <<< ${ssh_private_key_base64} >> ~/.ssh/id_rsa
sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 600 ~/.ssh/id_rsa.pub
eval $(ssh-agent -s)
echo "echo ${ssh_passphrase}" >> ./passphrase
sudo chmod 700 ./passphrase
DISPLAY=1 SSH_ASKPASS="./passphrase" ssh-add ~/.ssh/id_rsa < /dev/null
rm ./passphrase
