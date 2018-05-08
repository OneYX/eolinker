#!/bin/sh

nohup nginx > start-nginx.log 2>&1 &
nohup php-fpm7 > start-php.log 2>&1 &
/bin/sh