#!/bin/bash
set -ex

apt update
apt install apache2 mariadb-server php libapache2-mod-php php-mysql php-curl php-gd php-intl php-mbstring php-xml php-zip php-bcmath php-imagick unzip wget git -y

PHP_VER=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
PHP_INI="/etc/php/${PHP_VER}/apache2/php.ini"

sed -i "s/^memory_limit = .*/memory_limit = 256M/" $PHP_INI
sed -i "s/^upload_max_filesize = .*/upload_max_filesize = 128M/" $PHP_INI
sed -i "s/^post_max_size = .*/post_max_size = 128M/" $PHP_INI
sed -i "s/^;max_input_vars = .*/max_input_vars = 5000/" $PHP_INI

cp /vagrant/conf/000-default.conf /etc/apache2/sites-available/000-default.conf
a2enmod rewrite headers
systemctl restart apache2