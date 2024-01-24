#!/bin/bash
# caminho: infra/start.sh
mkdir -p /var/log/php \
&& touch /var/log/php/errors.log \
&& chmod 777 /var/log/php/errors.log \
&& chown -R www-data:www-data /var/www/bootstrap/cache \
&& chown -R www-data:www-data /var/www/storage \
&& chown -R www-data:www-data /var/log/php \
&& mkdir -p /var/run/php \
&& chown -R www-data:www-data /var/run/php \
&& chmod -R 775 /var/www/storage

/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
