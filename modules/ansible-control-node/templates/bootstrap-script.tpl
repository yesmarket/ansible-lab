#!/bin/bash
cd /home/${username}
echo ${ssh_public_key} >> ./.ssh/id_rsa.pub
base64 -d <<< ${ssh_private_key_base64} >> ./.ssh/id_rsa
sudo chmod 644 ./.ssh/id_rsa
sudo chmod 644 ./.ssh/id_rsa.pub
cat > ./.profile << EOL
eval \$(ssh-agent -s)

/usr/bin/keychain \$HOME/.ssh/id_rsa
source \$HOME/.keychain/\$HOSTNAME-sh
EOL
echo "${username}:${password}" | sudo chpasswd
python3 -m pip install --user argcomplete
export PATH=/home/${username}/.local/bin:$PATH
activate-global-python-argcomplete --user
git config --global user.email "${email}"
git config --global user.name "${name}"
