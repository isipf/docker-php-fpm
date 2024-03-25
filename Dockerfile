FROM chialab/php:8.0-fpm
LABEL maintainer="dev@isi.pf"

# Version: 8.0

# Download script to install PHP extensions and dependencies
#ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

# user1:1000 and user2:1001
RUN set -o errexit -o nounset \
    && echo "Adding user1 user and group" \
    && groupadd --system --gid 1000 u1000 \
    && useradd --system --gid u1000 --uid 1000 --shell /bin/bash --create-home u1000 \
    && echo "Adding user2 user and group" \
    && groupadd --system --gid 1001 u1001 \
    && useradd --system --gid u1001 --uid 1001 --shell /bin/bash --create-home u1001

RUN DEBIAN_FRONTEND=noninteractive apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
       zlib1g-dev \
       msmtp \
       msmtp-mta \
       locales locales-all \
    && install-php-extensions grpc 

# Install WP-CLI
RUN set -o errexit -o nounset \
    && echo "Install WP-CLI..." \
    && curl  https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/bin/wp \
    && chmod +x /usr/bin/wp \
    && /usr/bin/wp --info

