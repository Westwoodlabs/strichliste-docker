#!/bin/sh
set -e

# default values for UID and GID
UID=${UID:-1000}
GID=${GID:-1000}

# set user and group id for apache user
usermod -u $UID www-data
groupmod -g $GID www-data

# upstream entrypoint (php:*-apache)
exec docker-php-entrypoint $@