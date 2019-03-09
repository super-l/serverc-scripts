#!/bin/bash

#--------------------------------------------
# auto install apache+php
# author:    superl[n.s.t]  qq:86717375
# blog:      www.superl.org   github:https://github.com/super-l
# system:    centos7
#--------------------------------------------

# chmod a+x apache_php.sh
# Run: ./apache_php.sh port webname domain
# Run Example: ./apache_php.sh 80 test test.superl.org

# install apache
echo -e "\n\e[1;36mStart  -->>Install apache"
yum install httpd -y

# install php
echo -e "\n\e[1;36mStart  -->>Install php"
yum install php -y

# firewall
echo -e "\n\e[1;36mStart  -->>Update firewall"
firewall-cmd --zone=public --add-port=$1/tcp --permanent
systemctl restart firewalld.service


echo -e "\n\e[1;36mStart  -->>Install php packages"
# install PDO 
yum install php-pdo -y
# install php-mysql
yum install php-mysql -y
# install mbstring
yum -y install php-mbstring -y

echo -e "\n\e[1;36mStart  -->>Create Virtual config dir"
# Create Virtual config dir
mkdir /etc/httpd/sites-available
mkdir /etc/httpd/sites-enabled



echo -e "\n\e[1;36mStart  -->>Update httpd.conf"

# edit httpd.conf
if [ $1 != 80 ]
then
   sed -i "/^Listen/cListen $1" /etc/httpd/conf/httpd.conf  
fi

sed -i '56a IncludeOptional sites-enabled/*.conf' /etc/httpd/conf/httpd.conf

echo -e "\n\e[1;36mStart  -->>Create web dir"
mkdir -p /home/www/$2/

echo -e "\n\e[1;36mStart  -->>create file:/home/www/"$2"/index.html"
echo "Hello,Welcome~" > /home/www/$2/index.html

echo -e "\n\e[1;36mStart  -->>create file:/home/www/"$2"/index.php"
echo "<?php phpinfo(); ?>" > /home/www/$2/index.php

filePath="/etc/httpd/sites-available/$2.conf"
if [ ! -f "$filePath" ];then
  echo -e "\n\e[1;36mStart  -->>create file:"$filePath
  touch $filePath
  echo "<VirtualHost *:$1>" >> $filePath
  echo "\n    ServerName $3" >> $filePath
  echo "\n    ServerAlias $3" >> $filePath
  echo "\n    DocumentRoot /home/www/$2" >> $filePath
  echo "\n    ErrorLog \"| /usr/sbin/rotatelogs /home/logs/apache/$2_%Y_%m_%d_error.log 86400 480\"" >> $filePath
  echo "\n    CustomLog \"| /usr/sbin/rotatelogs /home/logs/apache/$2_%Y_%m_%d_access.log 86400 480\" common" >> $filePath 
  echo "\n    <Directory \"/home/www/$2\">" >> $filePath
  echo "\n       Options +Includes -Indexes" >> $filePath
  echo "\n       AllowOverride All>" >> $filePath
  echo "\n       Require all granted>" >> $filePath
  echo "\n    </Directory>" >> $filePath
  echo "</VirtualHost>" >> $filePath
else
  echo -e "\n\e[1;36mERROR  -->>is not empty:"$filePath
fi

ln -s /etc/httpd/sites-available/$2.conf /etc/httpd/sites-enabled/$2.conf
echo -e "\n\e[1;36mStart  -->>Create Config File Link"

systemctl restart httpd
echo -e "\n\e[1;36mStart  -->>Restart Apache Service"

systemctl enable httpd.service
echo -e "\n\e[1;36mStart  -->>Set Apache auto run"

echo -e "\n\e[1;36mStart  -->>View Apache status"
service httpd status

echo "Port:"$1
echo "Web Path:/home/www/"$2
echo "virtualFile:"$filePath
echo "Domain:"$3
