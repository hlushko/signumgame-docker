#!/bin/sh
set -e

REPOSITORY=${REPOSITORY}
BRANCH=${BRANCH:-'master'}

if ! [ -d app ]; then
    echo "Project sources not found. Cloning $BRANCH branch..."
    git clone -b "$BRANCH" "$REPOSITORY" app
else
    echo "Project sources found. Updating $BRANCH branch..."
    cd app
    git pull origin "$BRANCH"
fi

if [ "$1" = "php-fpm" ]; then
    echo "Installing vendors..."
    echo "Skip it"
#    composer install

#    echo "Copying configuration files..."
#    cp -Rv /usr/src/vts/. .

#    while ! nc -z vts-mariadb 3306; do
#        echo "Waiting for vts-mariadb..."
#        sleep 2s
#    done

#    echo "Execute DB migrations..."
#    app/console doctrine:migrations:migrate -n

#    echo "Working around assets:"
#    echo "--> Install..."
#    app/console assets:install
#    echo "--> Dump..."
#    app/console assetic:dump
#    echo "--> Dump JS Routing..."
#    app/console fos:js-routing:dump

fi

chown -R www-data:www-data .

exec "$@"
