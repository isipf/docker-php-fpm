FROM php:8.3-fpm
LABEL maintainer="dev@isi.pf"

# Version: 8.3

# Download script to install PHP extensions and dependencies
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

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
       curl \
       git \
       zip unzip \
       libbrotli1 \
       zlib1g-dev \
       msmtp \
       msmtp-mta \
       locales locales-all; \
    dpkg-query -W -f='${Package} ${Version}\n' libbrotli1; \
    rm -rf /var/lib/apt/lists/*

# Extensions from chialab/docker-php (iconv, mbstring and pdo_sqlite are already built-in) + grpc
RUN install-php-extensions \
      amqp \
      bcmath \
      bz2 \
      calendar \
      event \
      exif \
      gd \
      gettext \
      imagick \
      intl \
      ldap \
      memcached \
      mysqli \
      opcache \
      pdo_mysql \
      pdo_pgsql \
      pgsql \
      redis \
      soap \
      sockets \
      xsl \
      zip \
      grpc

# Install Composer.
ENV PATH=$PATH:/root/composer/vendor/bin \
  COMPOSER_ALLOW_SUPERUSER=1 \
  COMPOSER_HOME=/root/composer
RUN cd /opt \
    && curl -sSL https://getcomposer.org/installer > composer-setup.php \
    && curl -sSL https://composer.github.io/installer.sha384sum > composer-setup.sha384sum \
    && sha384sum --check composer-setup.sha384sum \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer --2 \
    && rm /opt/composer-setup.php /opt/composer-setup.sha384sum

# Install WP-CLI
RUN set -o errexit -o nounset \
    && echo "Install WP-CLI..." \
    && curl  https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/bin/wp \
    && chmod +x /usr/bin/wp \
    && /usr/bin/wp --info

