cd /home/forge/$site
git checkout -- . && git reset --hard HEAD && git clean -df
git pull origin master
composer install --optimize-autoloader --no-dev
npm run prod
php artisan migrate:refresh --seed

( flock -w 10 9 || exit 1
    echo 'Restarting FPM...'; sudo -S service php7.4-fpm reload ) 9>/tmp/fpmlock
