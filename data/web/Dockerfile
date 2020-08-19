FROM alpine:3.8 as release

RUN apk --no-cache add ca-certificates \
    && apk --no-cache add \
    curl \
    tar

RUN mkdir /source
WORKDIR /source
RUN curl -Lo strichliste.tar.gz https://github.com/strichliste/strichliste/releases/download/v1.7.1/strichliste.tar.gz
RUN tar -xf strichliste.tar.gz
RUN rm -r strichliste.tar.gz

FROM php:7.3-apache

RUN docker-php-ext-install pdo_mysql

COPY --from=release /source /var/www/html

RUN chown -R www-data:www-data /var/www/html

# configure apache
COPY ./apache.conf /etc/apache2/sites-available/000-default.conf