#!/usr/bin/env  -S  bash -xuo pipefail

#mkdir -p /mnt/dvd
#mount /dev/sr1 /mnt/dvd/
#apt-get update

systemctl stop unattended-upgrades
systemctl disable --now unattended-upgrades
sed -i 's/Unattended-Upgrade "1"/Unattended-Upgrade "0"/g' /etc/apt/apt.conf.d/20auto-upgrades

#export DEBIAN_FRONTEND=noninteractive
#apt install -y --no-install-recommends libldap2-dev libsasl2-dev python3-venv python3-pymysql python3-ldap python3-pip ansible python3-dev libxml2-dev libxslt1-dev zlib1g-dev libsasl2-dev build-essential libssl-dev libffi-dev libmysqlclient-dev libjpeg-dev libpq-dev libjpeg8-dev liblcms2-dev libblas-dev libatlas-base-dev

#apt install -y mariadb-server-10.6
#apt install -y mariadb-server
pip install PyMySQL python-ldap

mysql_secure_installation <<EOF

y
y
3tango
3tango
y
n
y
y
EOF

git clone https://github.com/berkink-nvidia-com/bcm-ansible-installer.git /home/ubuntu/bcm-ansible-installer
cd /home/ubuntu/bcm-ansible-installer
python3 -m venv venv
source venv/bin/activate
pip install -r requirements-control-node.txt
ansible-galaxy collection install -r requirements.yml
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
