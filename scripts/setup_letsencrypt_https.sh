#!/bin/bash
set -ex

source /vagrant/scripts/.env

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=ES/ST=Extremadura/L=Merida/O=ASIR/CN=$DOMAIN"

a2enmod ssl
a2ensite default-ssl
sed -i "s|/etc/ssl/certs/ssl-cert-snakeoil.pem|/etc/ssl/certs/apache-selfsigned.crt|" /etc/apache2/sites-available/default-ssl.conf
sed -i "s|/etc/ssl/private/ssl-cert-snakeoil.key|/etc/ssl/private/apache-selfsigned.key|" /etc/apache2/sites-available/default-ssl.conf
sed -i "s|DocumentRoot /var/www/html|DocumentRoot /var/www/html\n\t\t<Directory /var/www/html>\n\t\t\tAllowOverride All\n\t\t</Directory>|" /etc/apache2/sites-available/default-ssl.conf

systemctl restart apache2