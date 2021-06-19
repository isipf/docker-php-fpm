FROM chialab/php:7.4-fpm
LABEL maintainer="dev@isi.pf"

# Version: 7.4

# Download script to install PHP extensions and dependencies
#ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

# user1:1000 and user2:1001
RUN set -o errexit -o nounset \
    && echo "Adding user1 user and group" \
    && groupadd --system --gid 1000 user1 \
    && useradd --system --gid gradle --uid 1000 --shell /bin/bash --create-home user1 \
    && echo "Adding user2 user and group" \
    && groupadd --system --gid 1001 user2 \
    && useradd --system --gid gradle --uid 1001 --shell /bin/bash --create-home user2


#RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

RUN DEBIAN_FRONTEND=noninteractive apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
       zlib1g-dev \
       msmtp \
       msmtp-mta \
#       php-dev \
#       php-pear \
#      curl \
#      git \
#      zip unzip \
    && install-php-extensions \
      grpc\
# already installed:
#      bcmath \
#      bz2 \
#      calendar \
#      exif \
#      gd \
#      intl \
#      ldap \
#      memcached \
#      mysqli \
#      opcache \
#      pdo_mysql \
#      pdo_pgsql \
#      pgsql \
#      redis \
#      soap \
#      xsl \
#      zip \
#      sockets \
#      iconv \
#      mbstring \
    && a2enmod rewrite

# Install Composer.
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
#    && ln -s $(composer config --global home) /root/composer
#ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

# Install prestissimo (composer plugin). Plugin that downloads packages in parallel to speed up the installation process
# After release of Composer 2.x, remove prestissimo, because parallelism already merged into Composer 2.x branch:
# https://github.com/composer/composer/pull/7904
#RUN composer global require hirak/prestissimo

# Install WP-CLI
RUN set -o errexit -o nounset \
    && echo "Install WP-CLI..." \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp \
    && /usr/local/bin/wp --info

