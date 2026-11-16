FROM chialab/php:8.3-fpm
LABEL maintainer="dev@isi.pf"

# Version: 8.3

# Download script to install PHP extensions and dependencies
#ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

# user1:1000 and user2:1001
RUN set -o errexit -o nounset \
    && echo "Adding u1000 user and group" \
    && groupadd --system --gid 1000 u1000 \
    && useradd --system --gid u1000 --uid 1000 --shell /bin/bash --create-home u1000 \
    && echo "Adding u1001 user and group" \
    && groupadd --system --gid 1001 u1001 \
    && useradd --system --gid u1001 --uid 1001 --shell /bin/bash --create-home u1001

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
       libbrotli1 \
       zlib1g-dev \
       msmtp \
       msmtp-mta \
       locales locales-all; \
    dpkg-query -W -f='${Package} ${Version}\n' libbrotli1; \
    rm -rf /var/lib/apt/lists/*

RUN  install-php-extensions grpc 

# Install WP-CLI
RUN set -o errexit -o nounset \
    && echo "Install WP-CLI..." \
    && curl  https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/bin/wp \
    && chmod +x /usr/bin/wp \
    && /usr/bin/wp --info

