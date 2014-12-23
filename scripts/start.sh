#!/usr/bin/env bash

CONFIGDIR="/tmp/configs/"

# Setup in order to use with Vagrant
useradd vagrant
echo "vagrant" | passwd --stdin vagrant
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
echo "root" | passwd --stdin vagrant

# Insecure SSH key used for Vagrant
mkdir /home/vagrant/.ssh
cp ${CONFIGDIR}ssh/authorized_keys /home/vagrant/.ssh/authorized_keys
chmod 644 /home/vagrant/.ssh/authorized_keys
rm -rf /etc/ssh/sshd_config
cp ${CONFIGDIR}ssh/sshd_config /etc/ssh/sshd_config
service sshd restart

# Disable SELINUX
sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux
setenforce 0

sleep 2

# MAKE has problems when clock is not set
service ntpd stop
ntpdate 0.us.pool.ntp.org
service ntpd start

# Resolv
sed -i '/search/d' /etc/resolv.conf
sed -i '/domain/d' /etc/resolv.conf
sed -i '/10.0.2.3/d' /etc/resolv.conf
echo "nameserver 192.168.0.9" >> /etc/resolv.conf
echo "nameserver 192.168.0.4" >> /etc/resolv.conf

# Was having issues with repositories not installing from rpm.
cp /tmp/configs/repo/*.repo /etc/yum.repos.d/
cp /tmp/configs/gpg/* /etc/pki/rpm-gpg/
chmod 644 /etc/pki/rpm-gpg/*

sleep 5

# Packages
yum clean all
yum update -y
yum install vim git rsync wget gcc gcc-c++ make unzip -y

sleep 5

# NGINX
sudo yum install nginx -y
rm -rf /etc/nginx/nginx.conf
cp ${CONFIGDIR}nginx/nginx.conf /etc/nginx/nginx.conf
cp ${CONFIGDIR}nginx/moodle.local.lan.conf /etc/nginx/conf.d/moodle.local.lan.conf
cp ${CONFIGDIR}nginx/default.conf /etc/nginx/conf.d/default.conf

sleep 5

# HTTPD
sudo yum install httpd -y
rm -rf /etc/httpd/conf/httpd.conf
cp ${CONFIGDIR}httpd/httpd.conf /etc/httpd/conf/httpd.conf
cp ${CONFIGDIR}httpd/moodle.local.lan.conf /etc/httpd/conf.d/moodle.local.lan.conf
mkdir -p /var/www/local/moodle.local.lan
mkdir /var/www/local/moodle.local.lan/moodledata
chmod 777 /var/www/local/moodle.local.lan/moodledata
mkdir /var/www/local/moodle.local.lan/htdocs
chown -R apache:apache /var/www

sleep 5

# PHP 5.5
yum install php55w php55w-opcache php55w-cli php55w-devel php55w-gd php55w-intl php55w-mbstring php55w-mcrypt php55w-mysql php55w-pgsql php55w-soap php55w-xml php55w-common php55w-pear php55w-xmlrpc -y
yum install lua lua-devel libssh2 libssh2-devel -y
pecl install redis
yes '' | pecl install -f ssh2-beta
echo "extension=ssh2.so" > /etc/php.d/ssh2.ini

sleep 5

# MySQL
sudo yum install Percona-Server-server-55 -y
service mysql start
mysql --user='root' --password='' -e "CREATE DATABASE moodle DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql --user='root' --password='' -e "CREATE USER 'moodle'@'localhost' IDENTIFIED BY 'password';"
mysql --user='root' --password='' -e "GRANT ALL PRIVILEGES ON moodle.* TO 'moodle'@'localhost';"
mysql --user='root' --password='' -e "FLUSH PRIVILEGES;"

sleep 5

# Postgres
yum install postgresql94-server postgresql94-contrib postgresql94-devel -y
service postgresql-9.4 initdb
yum install v8 v8-devel mlocate -y
rm -rf /var/lib/pgsql/9.4/data/pg_hba.conf
cp ${CONFIGDIR}postgres/pg_hba.conf /var/lib/pgsql/9.4/data/pg_hba.conf
cp ${CONFIGDIR}postgres/fixfuncts.sql /var/lib/pgsql/fixfuncts.sql

sleep 5

# PLV8
cd
wget --no-check-certificate https://plv8js.googlecode.com/archive/df32150d63644a81a7a65aaac9af9c2f1886caa8.zip
unzip df32150d63644a81a7a65aaac9af9c2f1886caa8.zip
cd plv8js-df32150d6364/
# Timestamp was set to 2092 need to change to 2014
touch -d '30 August 2014' *
export PATH=$PATH:/usr/pgsql-9.4/bin
make
make install

sleep 5

# Services
chkconfig mysql on
chkconfig postgresql-9.4 on
chkconfig httpd on
chkconfig nginx on
chkconfig iptables off
sudo service postgresql-9.4 start
sudo service nginx restart
sudo service httpd restart
