#!/bin/sh
env > /environment
#env
groupadd -g $T_GID php-user
useradd -d /home/php-user -u $T_UID -g $T_GID -s /bin/bash php-user
mkdir -p /home/php-user/.local/bin
cp /root/composer.phar /home/php-user/.local/bin
chown -R php-user:php-user /home/php-user
touch /var/log/php7.2-fpm.log
chown php-user:php-user /var/log/php7.2-fpm.log
mkdir -p /run/php/
chown php-user:php-user /run/php/
#ls -lah /var/log
su php-user -c "php-fpm7.2 -y /etc/php/7.2/fpm/php-fpm.conf -c /etc/php/7.2/fpm/php.ini -F"
