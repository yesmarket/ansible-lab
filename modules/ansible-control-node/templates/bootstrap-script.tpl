#!/bin/bash
cd /home/${username}
echo ${ssh_public_key} >> ./.ssh/id_rsa.pub
base64 -d <<< ${ssh_private_key_base64} >> ./.ssh/id_rsa
sudo chmod 644 ./.ssh/id_rsa
sudo chmod 644 ./.ssh/id_rsa.pub
#echo "echo ${ssh_passphrase}" >> ./passphrase
#sudo chmod 644 ./passphrase
#su ${username}
#eval $(ssh-agent -s)
#DISPLAY=1 SSH_ASKPASS="./passphrase" ssh-add ./.ssh/id_rsa < /dev/null
#exit
#rm ./passphrase
echo -e "\neval \$(ssh-agent -s)" >> ./.profile
