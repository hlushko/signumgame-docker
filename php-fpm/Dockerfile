FROM php:7.0-fpm

RUN apt-get update && apt-get install -y \
        git \
        netcat \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) \
        iconv \
        mcrypt \
    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        gd \
        mbstring \
        pdo_mysql \
        sockets \
        zip \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
        libxml2-dev --no-install-recommends \
    && docker-php-ext-install soap \
    && docker-php-ext-enable opcache \
    && rm -rf /var/lib/apt/lists/*

# intl installation block start
ARG ICU_ARCHIVE
RUN curl -sS -o /tmp/icu.tar.gz -L $ICU_ARCHIVE \
    && tar -zxf /tmp/icu.tar.gz -C /tmp \
    && cd /tmp/icu/source \
    && ./configure --prefix=/usr/local \
    && make \
    && make install \
    && rm -rf /tmp/icu*

# PHP_CPPFLAGS are used by the docker-php-ext-* scripts
ENV PHP_CPPFLAGS="$PHP_CPPFLAGS -std=c++11"

RUN docker-php-ext-configure intl --with-icu-dir=/usr/local \
    && docker-php-ext-install intl \
    && rm -rf /var/lib/apt/lists/*
# intl installation block end

RUN curl -Ss https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY php.ini "$PHP_INI_DIR"/
COPY app.conf /usr/local/etc/php-fpm.d/

RUN mkdir -p /root/.ssh \
    && echo "\tHost *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

ARG USER_ID
ENV USER_ID $USER_ID
ARG GROUP_ID
ENV GROUP_ID $GROUP_ID

RUN [ -z $(getent group $GROUP_ID | cut -d: -f1) ] && groupmod -g $GROUP_ID www-data || true
RUN usermod -u $USER_ID -g $GROUP_ID www-data

WORKDIR /var/www

EXPOSE 9001

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]
