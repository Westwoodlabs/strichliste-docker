FROM php:8.1-apache

RUN docker-php-ext-install pdo_mysql

COPY ./build/ /var/www/html

RUN chown -R www-data:www-data /var/www

# configure apache
COPY ./assets/apache.conf /etc/apache2/sites-available/000-default.conf

# overwrite docker entrypoint
COPY ./assets/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["apache2-foreground"]