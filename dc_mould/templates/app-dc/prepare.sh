#!/usr/bin/env bash

# First time routine. Run as follows.
# > cd root-of-project
# > make {{data.app.name}}-prepare

mkdir -p bootstrap/cache
find ./bootstrap/cache ! -name .gitignore | xargs chmod 777

mkdir -p storage
find ./storage ! -name .gitignore | xargs chmod 777

composer install
php artisan key:generate

php artisan cache:clear
php artisan migrate
php artisan db:seed

# Seeders yet to come.

echo "Inserted DB with initial data."