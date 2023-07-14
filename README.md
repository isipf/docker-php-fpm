# isipf/php-fpm docker image

## What is it for ?
We needed a Docker image for php-fpm to host Wordpress websites
with its own files (including wordpress core files, plugins and themes)
. those file aren't to be using www-data as file owner in order to keep it from having core files untouched by php-fpm runtime.
user1 (uid 1000) and user (uid 1001) are to be possible owners of the files, so they are created by default.

## What does it come with ?

- (directly derived from chialab/php:fpm-7.4)
- php-fpm
- composer
- wp-cli
- msmtp mstmp-mta for contacting a mail relay (Postfix on another docker for example)