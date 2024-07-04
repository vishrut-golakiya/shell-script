#!/bin/bash


if [ -z "8.1" ]; then
# if [ -z "$1" ]; then
    echo "Supported PHP versions: 7.2, 7.4, 8.0, 8.1, 8.2"
    exit 1
fi

PHP_VERSION="8.1"
# PHP_VERSION=$1


SUPPORTED_VERSIONS=("7.2" "7.4" "8.0" "8.1" "8.2")


if [[ ! " ${SUPPORTED_VERSIONS[@]} " =~ " ${PHP_VERSION} " ]]; then
    echo "provide correct php version"
    echo "Supported PHP versions: 7.2, 7.4, 8.0, 8.1, 8.2"
    exit 1
fi
version=$(php -v)

if [ ! -z "$version" ]; then
    echo "PHP is already installed: $version"
    exit 1
fi

sudo apt-get update

sudo apt-get install -y php${PHP_VERSION}

sudo php${PHP_VERSION}-cli php${PHP_VERSION}-fpm php${PHP_VERSION}-mysql php${PHP_VERSION}-sqlite3 php${PHP_VERSION}-mbstring php${PHP_VERSION}-xml php${PHP_VERSION}-curl php${PHP_VERSION}-zip php${PHP_VERSION}-gd php${PHP_VERSION}-intl php${PHP_VERSION}-bcmath php${PHP_VERSION}-soap php${PHP_VERSION}-tokenizer

sudo systemctl restart php${PHP_VERSION}-fpm

echo "PHP ${PHP_VERSION} and required extensions for Laravel 10 installed successfully."
