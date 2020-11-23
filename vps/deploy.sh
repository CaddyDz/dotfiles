#!/bin/bash
RED='\033[0;31m'
NC='\033[0m' # No Color
site=$1
if [[ -n "$name" ]]; then
    cd /home/forge/$1
    git checkout -- . && git reset --hard HEAD && git clean -df
    git pull origin master
    composer install --optimize-autoloader --no-dev
    npm run prod
    php artisan migrate:refresh --seed --force
    php artisan l5-swagger:generate

    ( flock -w 10 9 || exit 1
        echo 'Restarting FPM...'; sudo -S service $FORGE_PHP_FPM reload ) 9>/tmp/fpmlock
else
    echo "${RED}Error:${NC} Enter site name"
    exit 1
fi
