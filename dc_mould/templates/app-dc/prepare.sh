#!/usr/bin/env bash

# First time routine. Run as follows.
# > cd root-of-main-repo
# > make prepare-all

composer install
php artisan key:generate

php artisan cache:clear
php artisan migrate
php artisan db:seed

# Seeders yet to come.

echo "Inserted DB with initial data."