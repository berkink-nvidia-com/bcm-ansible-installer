#!/usr/bin/env  -S  bash -xuo pipefail
mkdir -p /mnt/dvd
mount /dev/cdrom /mnt/dvd/
apt-get update
export DEBIAN_FRONTEND=noninteractive
apt install -y --no-install-recommends libldap2-dev libsasl2-dev python3.10-venv mariadb-server
pip install PyMySQL python-ldap
mysql_secure_installation <<EOF
n
y
n
y
y
EOF
python3 -m venv venv
source venv/bin/activate
pip install -r requirements-control-node.txt
ansible-galaxy collection install brightcomputing.installer100
ansible-playbook -i inventory/hosts playbook.yml
systemctl enable tftpd.socket
systemctl start tftpd.socket
export MODULES_USE_COMPAT_VERSION=1
export MODULEPATH=/cm/local/modulefiles:/cm/shared/modulefiles
source /cm/local/apps/environment-modules/current/init/bash
module load cmsh
module load cm-image
mkdir -p /mnt/dvd
mount /dev/cdrom /mnt/dvd/
cm-lite-daemon-repo /mnt/dvd
