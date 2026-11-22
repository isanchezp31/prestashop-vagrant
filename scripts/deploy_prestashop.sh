#!/bin/bash
set -ex

source /vagrant/scripts/.env

mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME;"
mysql -u root <<< "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'localhost';"
mysql -u root <<< "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
mysql -u root <<< "FLUSH PRIVILEGES;"

rm -rf /var/www/html/*
wget https://github.com/PrestaShop/PrestaShop/releases/download/${PS_VERSION}/prestashop_${PS_VERSION}.zip -O /tmp/prestashop.zip
unzip /tmp/prestashop.zip -d /tmp/ps_extract
unzip /tmp/ps_extract/prestashop.zip -d /var/www/html/
rm -rf /tmp/prestashop.zip /tmp/ps_extract

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

sudo -u www-data php /var/www/html/install/index_cli.php \
  --domain="$DOMAIN" \
  --db_server="localhost" \
  --db_name="$DB_NAME" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --prefix="ps_" \
  --language="$PS_LANGUAGE" \
  --country="$PS_COUNTRY" \
  --name="$PS_SHOP_NAME" \
  --firstname="Imanol" \
  --lastname="Sanchez" \
  --email="$PS_ADMIN_MAIL" \
  --password="$PS_ADMIN_PASSWD" \
  --ssl=1

rm -rf /var/www/html/install
mv /var/www/html/admin /var/www/html/$PS_FOLDER_ADMIN